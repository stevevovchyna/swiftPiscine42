//
//  FirstViewController.swift
//  Siri
//
//  Created by Steve Vovchyna on 21.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit
import sapcai

class FirstViewController: UIViewController {

    var bot = SapcaiClient(token : "0dedc07f4cf04e658b15ad041b2a5feb", language: "en")
    
    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var textInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if let request = textInput.text {
            self.bot.analyseText(request, successHandler: { (response) in
                print(response.toJSONString()! as Any)
                if response.entities?.toJSON().count == 0 {
                    self.responseLabel.text = "Error getting data with your request"
                } else if let jsonResponse = response.entities?.locations?[0].toJSON() {
                    self.responseLabel.text = ("The location is \(String(describing: jsonResponse["lat"]!)) and \(String(describing: jsonResponse["lng"]!))")
                }
                
            }) { (error) in
                print(error)
                self.responseLabel.text = error.localizedDescription
            }
        }
    }
    

}
