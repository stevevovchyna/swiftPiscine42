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
import SystemConfiguration

public class Reachability {

    class func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret
        
    }
}

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, SFSpeechRecognizerDelegate {

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
    
    let audioEngine: AVAudioEngine = AVAudioEngine()
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
        myTableView.separatorStyle = .none
        
        textInput.delegate = self

        sendButton.layer.cornerRadius = 10
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        myTableView.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
                
        if !micAccessIsGranted() {
            self.disableMicButton()
        }
    }
    
    //MARK:- TableView methods
    
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
    
    func scrollTableView() {
        let indexPath = IndexPath(row: self.messagesArray.count - 1, section: 0)
        self.myTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    @objc func tableViewTapped() {
        textInput.endEditing(true)
    }
    
    //MARK:- Recognition methods
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if !available {
            self.presentAlert(alertTitle: "Problem accessing recognizer", alertMessage: "Please try again later")
        }
    }
    
    func recordAndRecognizeSpeech() {
        self.request = SFSpeechAudioBufferRecognitionRequest()   // recreates recognitionRequest object.
        let node = audioEngine.inputNode
        node.removeTap(onBus: 0)
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat){ buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            return print("ASHIIIIIBKAAAA!!!!1111", error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else { return }
        if !myRecognizer.isAvailable {
            return
        }
        
        self.recordButtonView.layer.backgroundColor = UIColor.red.cgColor
        self.recordButtonView.layer.cornerRadius = self.recordButtonView.frame.size.height / 2
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
            if result != nil {
                if let result = result {
                    print(result.bestTranscription.formattedString)
                    let finalString = result.bestTranscription.formattedString
                    if self.audioEngine.isRunning {
                        self.textInput.text = finalString
                    }
                } else if let error = error {
                    print("ASHIBKAAAAAAAAAA", error)
                }
            }
        })
    }
    
    func stopRecording() {
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        self.recordButtonView.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    //MARK: - IBActions ****************
    
    @IBAction func voiceCommandButtonPressed(_ sender: UIButton) {
        if internetIsAvailable() {
            if audioEngine.isRunning {
                self.stopRecording()
            } else {
                self.recordAndRecognizeSpeech()
            }
        } else {
            presentAlert(alertTitle: "No internet connection", alertMessage: "Seems like your internet connection is down")
        }
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
    
    //MARK:- Keyboard Methods
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = 0
            self.scrollTableView()
            self.view.layoutIfNeeded()
        }
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
                    UIView.animate(withDuration: 0.1) {
                        self.scrollTableView()
                    }
                }
            })
        }
    }
    
    //MARK:- Permission checks
    
    func presentAlert(alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func micAccessIsGranted() -> Bool {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSessionRecordPermission.granted:
            print("Permission granted")
            return true
        case AVAudioSessionRecordPermission.denied:
            print("Pemission denied")
            return false
        default:
            return false
        }
    }
    
    func disableMicButton() {
        self.voiceCommandButton.isEnabled = false
        self.voiceCommandButton.layer.backgroundColor = UIColor.lightGray.cgColor
        self.voiceCommandButton.layer.cornerRadius = self.voiceCommandButton.frame.size.height / 2
    }
    
    func checkRecognitionPermission() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    print("We've got the voice recognition authorization - ready to go")
                case .denied:
                    self.presentAlert(alertTitle: "Speech recognizer not allowed", alertMessage: "You can enable the recognizer in Settings")
                    self.disableMicButton()
                case .restricted:
                    self.presentAlert(alertTitle: "Could not start the speech recognizer", alertMessage: "Check your internect connection and try again")
                    self.disableMicButton()
                case .notDetermined:
                    self.presentAlert(alertTitle: "Could not start the speech recognizer", alertMessage: "Check your internect connection and try again")
                    self.disableMicButton()
                default:
                    print("Something strange going on here")
                }
            }
        }
    }
    
    func internetIsAvailable() -> Bool {
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            return true
        } else {
            print("Internet Connection not Available!")
            return false
        }
    }
    
}
