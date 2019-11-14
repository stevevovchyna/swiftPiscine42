//
//  ViewController.swift
//  Tweets
//
//  Created by Steve Vovchyna on 14.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit

class ViewController: UIViewController, APITwitterDelegate {
    
    var twitterAPIID = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let string = "https://api.twitter.com/1.1/search/tweets.json?q=apple"
        let url = NSURL(string: string)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue(twitterAPIID, forHTTPHeaderField: "oauth_consumer_key")
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let error = error {
                print("error: \(error)")
            } else {
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                }
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("data: \(dataString)")
                }
            }
        }
        task.resume()
    }

    func processTweets(tweets : [Tweet]) {
        
    }
    
    func tweetError(error: NSError) {
        
    }

}

