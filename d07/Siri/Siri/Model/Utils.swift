//
//  Utils.swift
//  Siri
//
//  Created by Steve Vovchyna on 29.01.2020.
//  Copyright © 2020 Steve Vovchyna. All rights reserved.
//

import Foundation
import UIKit

let sapcaiToken = "0dedc07f4cf04e658b15ad041b2a5feb"
let darkSkyToken = "2b485393cb19279ada9959ed78f14c7a"

func fToC(_ temperature: Double) -> String {
    return String(describing: ((temperature - 32) * (5 / 9)).rounded())
}

func presentAlert(alertTitle: String, alertMessage: String, in view: UIViewController) {
    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
        view.dismiss(animated: true, completion: nil)
    }))
    view.present(alert, animated: true, completion: nil)
}
