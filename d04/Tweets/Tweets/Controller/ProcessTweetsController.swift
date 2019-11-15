//
//  ProcessTweetsController.swift
//  Tweets
//
//  Created by Steve Vovchyna on 14.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit

protocol APITwitterDelegate {
    func processTweets(tweets : [Tweet])
    func tweetError(error: NSError)
}

class ProcessTweetsController {
    
    var delegate : APITwitterDelegate?
    var token : String = ""
    var foundTweets : [Tweet] = []
    
    init(delegate: APITwitterDelegate?, token: String) {
        self.delegate = delegate
        self.token = token
    }
    
    static func oAuthTwitter(with viewController: ViewController) {
        let apiKey = "xDh7xsxMn1FMNCVv44hfOncSy"
        let secretAPIKey = "qkTIi69yI07KQzJ3Gc54TR7WB3Y5poFVGSzO9sls7j8unKOgbX"
        let authString = "https://api.twitter.com/oauth2/token"
        let url = URL(string: authString)
        let bearer = ((apiKey + ":" + secretAPIKey).data(using: String.Encoding.utf8))!.base64EncodedString(options: NSData.Base64EncodingOptions())
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Basic " + bearer, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                if json["access_token"] as? String == nil {
                    DispatchQueue.main.sync {
                        let userInfo: [String : Any] = [ NSLocalizedDescriptionKey :  NSLocalizedString("Authentication", value: "Failed to Authenticate", comment: "") ]
                        viewController.tweetError(error: NSError(domain: "https://api.twitter.com/1.1/search/tweets.json", code: 401, userInfo: userInfo))
                        }
                    return
                } else {
                    viewController.token = json["access_token"] as? String
                    viewController.processTweetsController = ProcessTweetsController(delegate: viewController, token: viewController.token!)
                    viewController.processTweetsController?.searchTweets(searchQuery: viewController.searchQuery)
                }
            }
        }.resume()
    }
    
    func searchTweets(searchQuery: String) {
        let query = searchQuery.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let urlString = "https://api.twitter.com/1.1/search/tweets.json?q=" + query! + "&lang=en&result_type=recent&count=100"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer " + self.token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                DispatchQueue.main.sync {
                    let userInfo: [String : Any] = [ NSLocalizedDescriptionKey :  NSLocalizedString("Authentication", value: "Failed to Authenticate", comment: "") ]
                    self.delegate?.tweetError(error: NSError(domain: "https://api.twitter.com/1.1/search/tweets.json", code: 401, userInfo: userInfo))
                    return
                }
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                
                let responseTweets = json["statuses"] as? [[String:Any]]
                
                if responseTweets!.count < 1 {
                    DispatchQueue.main.sync {
                        let userInfo: [String : Any] = [ NSLocalizedDescriptionKey :  NSLocalizedString("Empty Result", value: "Search: \(query!) didn't return any results", comment: "") ]
                        self.delegate?.tweetError(error: NSError(domain: "https://api.twitter.com/1.1/search/tweets.json", code: 401, userInfo: userInfo))
                        return
                    }
                }
                self.foundTweets.removeAll()
                for tweet in responseTweets! {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "E MMM dd HH:mm:ss Z yyyy"
                    let newDate = dateFormatter.date(from: tweet["created_at"] as! String)
                    dateFormatter.dateFormat = "dd MMM, yyyy h:mm:ss"
                    let date = dateFormatter.string(from: newDate!)
                    let user = tweet["user"] as AnyObject
                    let name = user["name"] as! String
                    let text = tweet["text"] as! String
                    let newTweet = Tweet(name: name, text: text, date: date)
                    self.foundTweets.append(newTweet)
                }
            }
            DispatchQueue.main.sync {
                self.delegate?.processTweets(tweets: self.foundTweets)
            }
        }.resume()
    }
    
}
