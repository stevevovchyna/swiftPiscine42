//
//  FirstViewController.swift
//  Siri
//
//  Created by Steve Vovchyna on 21.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit
import sapcai
import DarkSkyKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var bot = SapcaiClient(token : "0dedc07f4cf04e658b15ad041b2a5feb", language: "en")
    let forecastClient = DarkSkyKit(apiToken: "2b485393cb19279ada9959ed78f14c7a")
    var messagesArray = ["Bot: Hi there! Don't hesitate to ask me about a weather in different places!"]
    var keyboardHeight : CGFloat = 0
    

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textInput: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var myTableView: UITableView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .none
        
        textInput.delegate = self
        textInput.layer.borderColor = UIColor.lightGray.cgColor
        textInput.layer.borderWidth = 1.0
        textInput.layer.cornerRadius = 10
        
        sendButton.layer.cornerRadius = 10
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        myTableView.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 0.5){
                self.heightConstraint.constant = self.keyboardHeight
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)

        cell.textLabel?.text = messagesArray[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        if indexPath.row % 2 != 0 {
            cell.textLabel?.textAlignment = .right
            cell.backgroundColor = UIColor.darkGray
            cell.textLabel?.textColor = UIColor.white
        } else {
            cell.backgroundColor = UIColor.lightGray
        }
        cell.layer.cornerRadius = 20
        cell.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        messagesArray.append("You: \(textInput.text ?? "* said nothing *")")
        myTableView.reloadData()
        if let request = textInput.text {
            textInput.text = ""
            self.bot.analyseText(request, successHandler: { (response) in
//                print(response.toJSONString()! as Any)
                if response.entities?.locations == nil {
                    self.messagesArray.append("Bot: Sorry, couldn't get the data with your request")
                    self.myTableView.reloadData()
                } else if let jsonResponse = response.entities?.locations?[0].toJSON() {
                    self.forecastClient.current(latitude: Double(jsonResponse["lat"] as! Float), longitude: Double(jsonResponse["lng"] as! Float)) { result in
                      switch result {
                        case .success(let forecast):
                            if let current = forecast.currently {
//                                print(forecast.currently as Any)
                                self.messagesArray.append("Bot: It is \(String(describing: ((current.temperature! - 32) * (5 / 9)).rounded())) ℃ and \(current.icon!) in \(String(describing: jsonResponse["raw"]!))")
                                self.myTableView.reloadData()
                            }
                        case .failure(let error):
                            print(error)
                      }
                    }
                }
            }) { (error) in
                print(error)
                self.messagesArray.append("Bot: Ooops, there was some error! Please, make sure that your request is correct!")
                self.myTableView.reloadData()
            }
        }
    }
    
    @objc func tableViewTapped() {
        textInput.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = self.keyboardHeight
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = 33
            self.view.layoutIfNeeded()
        }
    }
    

}
