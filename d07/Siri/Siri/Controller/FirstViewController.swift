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
import Speech
import AVFoundation

class FirstViewController: UIViewController {

    var bot = SapcaiClient(token : sapcaiToken, language: "en")
    let forecastClient = DarkSkyKit(apiToken: darkSkyToken)
    var speech = SpeechRecognizer()
    private let tableViewDataSource = TableViewDataSource()
    
    var keyboardHeight : CGFloat = 0
    var recordingSession: AVAudioSession!
    
    @IBOutlet weak var wholeInputView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textInput: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var voiceCommandButton: UIButton!
    @IBOutlet weak var recordButtonView: UIView!
   
// MARK:- view lifecycle
    
    override func viewDidLoad() {
        recordingSession = AVAudioSession.sharedInstance()
        checkRecognitionPermission()
        myTableView.register(UINib(nibName: "CustomBotTableViewCell", bundle: nil), forCellReuseIdentifier: "customBotMessageCell")
        myTableView.register(UINib(nibName: "CustomUserTableViewCell", bundle: nil), forCellReuseIdentifier: "customUserMessageCell")
        myTableView.delegate = tableViewDataSource
        myTableView.dataSource = tableViewDataSource
        textInput.delegate = self
        myTableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tableViewTapped)))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
    }
    
//MARK: - IBActions ****************
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        processUserRequest()
    }
    
    @IBAction func voiceCommandButtonPressed(_ sender: UIButton) {
        switch internetIsAvailable() {
        case true:
            speech.audioEngine.isRunning ? speech.stopRecording(with: recordButtonView) : speech.recordAndRecognizeSpeech(in: textInput, with: recordButtonView, for: self)
        case false:
            presentAlert(alertTitle: "No internet connection", alertMessage: "Seems like your internet connection is down", in: self)
        }
    }
}

//MARK:- textField delegate methods
extension FirstViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = 0
            self.scrollTableView()
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textInput {
            processUserRequest()
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}

//MARK:- Recognition methods
extension FirstViewController: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if !available {
            presentAlert(alertTitle: "Problem accessing recognizer", alertMessage: "Please try again later", in: self)
        }
    }
}

//MARK:- private methods
extension FirstViewController {
    private func checkRecognitionPermission() {
        recordingSession.requestRecordPermission { [unowned self] micAuthStatus in
            SFSpeechRecognizer.requestAuthorization { authStatus in
                DispatchQueue.main.async {
                    if authStatus == .authorized, micAuthStatus {
                        self.setMicButton(to: true)
                    } else {
                        presentAlert(alertTitle: "Speech recognition or microfone are not allowed", alertMessage: "You can enable the recognizer or microfone in Settings", in: self)
                        self.setMicButton(to: false)
                    }
                }
            }
        }
    }
    
    private func setMicButton(to isEnabled: Bool) {
        DispatchQueue.main.async {
            self.voiceCommandButton.isEnabled = isEnabled
            let color : UIColor = isEnabled ? .clear : .lightGray
            self.voiceCommandButton.layer.backgroundColor = color.cgColor
            self.voiceCommandButton.layer.cornerRadius = self.voiceCommandButton.frame.size.height / 2
        }
    }
    
    private func internetIsAvailable() -> Bool { return Reachability.isConnectedToNetwork() ? true : false }
    
    private func addToTable(messages: [Message]) {
        tableViewDataSource.messagesArray.append(contentsOf: messages)
        myTableView.reloadData()
        scrollTableView()
        sendButton.isEnabled = true
    }
    
    private func scrollTableView() {
        let indexPath = IndexPath(row: tableViewDataSource.messagesArray.count - 1, section: 0)
        self.myTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    @objc func tableViewTapped() {
        textInput.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardHeight = keyboardRectangle.size.height
            UIView.animate(withDuration: 0.5, animations: {
                self.heightConstraint.constant = (self.keyboardHeight * -1) + self.view.safeAreaInsets.bottom
                self.view.layoutIfNeeded()
            }, completion: { _ in
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.1) { self.scrollTableView() }
                }
            })
        }
    }
    
    private func processUserRequest() {
        sendButton.isEnabled = false
        if speech.audioEngine.isRunning { speech.stopRecording(with: recordButtonView) }
        guard let text = textInput.text else { return }
        if text.count == 0 {
            let userMessage = Message(user: .user, text: "* said nothing *")
            let botMessage = Message(user: .bot, text: "Hey, at least type something!")
            addToTable(messages: [userMessage, botMessage])
        } else {
            let userMessage = Message(user: .user, text: text)
            tableViewDataSource.messagesArray.append(userMessage)
            myTableView.reloadData()
            scrollTableView()
            textInput.text = ""
            var botMessage = Message(user: .bot, text: "Sorry, couldn't get the data with your request")
            self.bot.analyseText(text, successHandler: { response in
                if response.entities?.locations == nil {
                    self.addToTable(messages: [botMessage])
                } else if let json = response.entities?.locations?[0].toJSON() {
                    let lat = Double(json["lat"] as! Float)
                    let lon = Double(json["lng"] as! Float)
                    self.forecastClient.current(latitude: lat, longitude: lon) { result in
                        switch result {
                        case .success(let forecast):
                            guard let current = forecast.currently else { return }
                            let temperature = fToC(current.temperature ?? 0)
                            let city = String(describing: json["raw"] ?? "Middle of Nowhere").capitalizingFirstLetter()
                            let conditions = current.icon ?? "raining frogs"
                            botMessage.message = "It is \(temperature) ℃ and \(conditions) in \(city)"
                        case .failure(let error):
                            botMessage.message = "Sorry, couldn't get the data with your request. Error is: \(error)"
                        }
                        self.addToTable(messages: [botMessage])
                    }
                }
            }) { error in self.addToTable(messages: [botMessage]) }
        }
    }
}
