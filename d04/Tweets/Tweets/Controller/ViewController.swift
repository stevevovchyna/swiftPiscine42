//
//  ViewController.swift
//  Tweets
//
//  Created by Steve Vovchyna on 14.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit

class ViewController: UIViewController, APITwitterDelegate {
    
    var token : String?
    var processTweetsController : ProcessTweetsController?
    var foundTweets : [Tweet] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProcessTweetsController.oAuthTwitter(with: self)
        
    }

    func processTweets(tweets : [Tweet]) {
        print(tweets)
    }
    
    func tweetError(error: NSError) {
        let alert = UIAlertController(title: error.userInfo["value"] as? String, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }

}

