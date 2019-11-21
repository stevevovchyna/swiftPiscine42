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

class FirstViewController: UIViewController {

    var bot = SapcaiClient(token : "0dedc07f4cf04e658b15ad041b2a5feb", language: "en")
    let forecastClient = DarkSkyKit(apiToken: "2b485393cb19279ada9959ed78f14c7a")
    
    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var textInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 0)
        if let request = textInput.text {
            self.bot.analyseText(request, successHandler: { (response) in
//                print(response.toJSONString()! as Any)
                if response.entities?.locations == nil {
                    self.responseLabel.text = "Error getting weather data with your request"
                } else if let jsonResponse = response.entities?.locations?[0].toJSON() {
                    self.forecastClient.current(latitude: Double(jsonResponse["lat"] as! Float), longitude: Double(jsonResponse["lng"] as! Float)) { result in
                      switch result {
                        case .success(let forecast):
                            if let current = forecast.currently {
//                            print(forecast.currently as Any)
                                blurEffectView.removeFromSuperview()
                            self.responseLabel.text = ("It is \(String(describing: ((current.temperature! - 32) * (5 / 9)).rounded())) ℃ and \(current.icon!) in \(String(describing: jsonResponse["raw"]!))")
                                
                        }
                        case .failure(let error):
                            print(error)
                      }
                    }
                }
                
            }) { (error) in
                print(error)
                self.responseLabel.text = error.localizedDescription
            }
        }
    }
    

}
