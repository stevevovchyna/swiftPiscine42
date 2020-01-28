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

    var bot = SapcaiClient(token : "0dedc07f4cf04e658b15ad041b2a5feb", language: "en")
    let forecastClient = DarkSkyKit(apiToken: "2b485393cb19279ada9959ed78f14c7a")
    var messagesArray : [Message] = [Message(user: .bot, text: "Hi there! Will be glad to help you with any of your weather requests! Don't hesitate to message me!")]
    var keyboardHeight : CGFloat = 0
    
    @IBOutlet weak var wholeInputView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textInput: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var voiceCommandButton: UIButton!
    @IBOutlet weak var recordButtonView: UIView!
    
    var audioEngine: AVAudioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    var request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    override func viewDidAppear(_ animated: Bool) {
        checkRecognitionPermission()
    }
    
    override func viewDidLoad() {
        myTableView.register(UINib(nibName: "CustomBotTableViewCell", bundle: nil), forCellReuseIdentifier: "customBotMessageCell")
        myTableView.register(UINib(nibName: "CustomUserTableViewCell", bundle: nil), forCellReuseIdentifier: "customUserMessageCell")
        myTableView.delegate = self
        myTableView.dataSource = self
        textInput.delegate = self
        myTableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tableViewTapped)))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if audioEngine.isRunning {
            self.stopRecording()
        }
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
    
    //MARK:- TableView methods
}

extension FirstViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch messagesArray[indexPath.row].user {
        case .bot:
            let botCell = tableView.dequeueReusableCell(withIdentifier: "customBotMessageCell", for: indexPath) as! CustomBotTableViewCell
            botCell.userMessageLabel.text = messagesArray[indexPath.row].message
            return botCell
        case .user:
            let userCell = tableView.dequeueReusableCell(withIdentifier: "customUserMessageCell", for: indexPath) as! CustomUserTableViewCell
            userCell.userMessageLabel.text = messagesArray[indexPath.row].message
            return userCell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func scrollTableView() {
        let indexPath = IndexPath(row: self.messagesArray.count - 1, section: 0)
        self.myTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    @objc func tableViewTapped() {
        textInput.endEditing(true)
    }
}

extension FirstViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = 0
            self.scrollTableView()
            self.view.layoutIfNeeded()
        }
    }
}

//MARK:- Recognition methods
extension FirstViewController: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if !available {
            self.presentAlert(alertTitle: "Problem accessing recognizer", alertMessage: "Please try again later")
        }
    }
    
    func recordAndRecognizeSpeech() {
        request = SFSpeechAudioBufferRecognitionRequest()
        let node = audioEngine.inputNode
        node.removeTap(onBus: 0)
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            recordButtonView.layer.backgroundColor = UIColor.lightGray.cgColor
            presentAlert(alertTitle: "Problem recognizing the speech", alertMessage: "Please try again later")
        }
        guard let myRecognizer = SFSpeechRecognizer(), myRecognizer.isAvailable else { return }
        recordButtonView.layer.backgroundColor = UIColor.red.cgColor
        recordButtonView.layer.cornerRadius = self.recordButtonView.frame.size.height / 2
        recognitionTask = speechRecognizer?.recognitionTask(with: request) { result, error in
            if result != nil {
                if let result = result {
                    print(result.bestTranscription.formattedString)
                    let finalString = result.bestTranscription.formattedString
                    if self.audioEngine.isRunning {
                        self.textInput.text = finalString
                    }
                } else if let error = error {
                    self.recordButtonView.layer.backgroundColor = UIColor.lightGray.cgColor
                    self.presentAlert(alertTitle: "Problem recognizing the speech", alertMessage: error.localizedDescription)
                }
            }
        }
    }
    
    func stopRecording() {
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            recognitionTask.finish()
            self.recognitionTask = nil
        }
        self.recordButtonView.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    //MARK: - IBActions ****************
    
    @IBAction func voiceCommandButtonPressed(_ sender: UIButton) {
        switch internetIsAvailable() {
        case true:
            audioEngine.isRunning ? stopRecording() : recordAndRecognizeSpeech()
        case false:
            presentAlert(alertTitle: "No internet connection", alertMessage: "Seems like your internet connection is down")
        }
    }
}

//MARK:- private methods
extension FirstViewController {
    private func setMicButton(to isEnabled: Bool) {
        DispatchQueue.main.async {
            self.voiceCommandButton.isEnabled = isEnabled
            let color : UIColor = isEnabled ? .clear : .lightGray
            self.voiceCommandButton.layer.backgroundColor = color.cgColor
            self.voiceCommandButton.layer.cornerRadius = self.voiceCommandButton.frame.size.height / 2
        }
    }
    
    private func checkRecognitionPermission() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            AVAudioSession.sharedInstance().requestRecordPermission { micAuthStatus in
                OperationQueue.main.addOperation {
                    if authStatus == .authorized, micAuthStatus {
                        self.setMicButton(to: true)
                    } else {
                        self.presentAlert(alertTitle: "Speech recognition or microfone are not allowed", alertMessage: "You can enable the recognizer or microfone in Settings")
                        self.setMicButton(to: false)
                    }
                }
            }
        }
    }
    
    private func presentAlert(alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func internetIsAvailable() -> Bool { return Reachability.isConnectedToNetwork() ? true : false }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardHeight = keyboardRectangle.size.height
            UIView.animate(withDuration: 0.5, animations: {
                self.heightConstraint.constant = (self.keyboardHeight * -1) + self.view.safeAreaInsets.bottom
                self.view.layoutIfNeeded()
            }, completion: { _ in
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.1) {
                        self.scrollTableView()
                    }
                }
            })
        }
    }
}
