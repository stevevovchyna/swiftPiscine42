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
    var messagesArray : [Message] = [Message(user: .bot, text: "Hi there! Will be glad to help you with any of your weather requests! Don't hesitate to message me!")]
    var keyboardHeight : CGFloat = 0
    

    @IBOutlet weak var wholeInputView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textInput: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var myTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.register(UINib(nibName: "CustomBotTableViewCell", bundle: nil), forCellReuseIdentifier: "customBotMessageCell")
        myTableView.register(UINib(nibName: "CustomUserTableViewCell", bundle: nil), forCellReuseIdentifier: "customUserMessageCell")
        
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .none
        
        textInput.delegate = self

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
            self.keyboardHeight = keyboardRectangle.size.height
            UIView.animate(withDuration: 0.5) {
                self.heightConstraint.constant = (self.keyboardHeight * -1) + self.view.safeAreaInsets.bottom
                self.view.layoutIfNeeded()
            }
            DispatchQueue.main.async {
                self.scrollTableView()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if messagesArray[indexPath.row].user == .bot {
            let botCell = tableView.dequeueReusableCell(withIdentifier: "customBotMessageCell", for: indexPath) as! CustomBotTableViewCell
            botCell.userMessageLabel.text = messagesArray[indexPath.row].message
            botCell.userMessageLabel.numberOfLines = 0
            botCell.userMessageView.layer.backgroundColor = #colorLiteral(red: 0.5271991709, green: 0.7516028796, blue: 0.4997833824, alpha: 0.5938570205)
            botCell.userMessageView.layer.cornerRadius = 10
            botCell.userPicView.layer.cornerRadius = botCell.userPicView.frame.size.height / 2
            return botCell
        } else {
            let userCell = tableView.dequeueReusableCell(withIdentifier: "customUserMessageCell", for: indexPath) as! CustomUserTableViewCell
            userCell.userMessageLabel.text = messagesArray[indexPath.row].message
            userCell.userMessageLabel.numberOfLines = 0
            userCell.userMessageView.layer.backgroundColor = #colorLiteral(red: 0.6983060804, green: 0.5963864472, blue: 0.7044952152, alpha: 0.6788848459)
            userCell.userMessageView.layer.cornerRadius = 10
            userCell.userImageLabel.layer.cornerRadius = userCell.userImageLabel.frame.size.height / 2
            return userCell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if textInput.text?.count == 0 {
            messagesArray.append(Message(user: .user, text: "* said nothing *"))
            self.messagesArray.append(Message(user: .bot, text: "Hey, at least type something!"))
            myTableView.reloadData()
            scrollTableView()
        } else {
            messagesArray.append(Message(user: .user, text: "\(textInput.text ?? "* said nothing *")"))
            myTableView.reloadData()
            scrollTableView()
            if let request = textInput.text {
                textInput.text = ""
                self.bot.analyseText(request, successHandler: { (response) in
                    if response.entities?.locations == nil {
                        self.messagesArray.append(Message(user: .bot, text: "Sorry, couldn't get the data with your request"))
                        self.myTableView.reloadData()
                        self.scrollTableView()
                    } else if let jsonResponse = response.entities?.locations?[0].toJSON() {
                        self.forecastClient.current(latitude: Double(jsonResponse["lat"] as! Float), longitude: Double(jsonResponse["lng"] as! Float)) { result in
                            switch result {
                            case .success(let forecast):
                                if let current = forecast.currently {
                                    self.messagesArray.append(Message(user: .bot, text: "It is \(String(describing: ((current.temperature! - 32) * (5 / 9)).rounded())) ℃ and \(current.icon!) in \(String(describing: jsonResponse["raw"]!))"))
                                    self.myTableView.reloadData()
                                    self.scrollTableView()
                                }
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                }) { (error) in
                    print(error)
                    self.messagesArray.append(Message(user: .bot, text: "Ooops, there was some error! Please, make sure that your request is correct!"))
                    self.myTableView.reloadData()
                    self.scrollTableView()
                }
            }
        }
    }
    
    func scrollTableView() {
        let indexPath = IndexPath(row: self.messagesArray.count - 1, section: 0)
        self.myTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    @objc func tableViewTapped() {
        textInput.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = 0
            self.scrollTableView()
            self.view.layoutIfNeeded()
        }
    }
}