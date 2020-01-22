//
//  ProcessTweetsController.swift
//  Tweets
//
//  Created by Stepan VOVCHYNA on 12/21/19.
//  Copyright © 2019 Stepan VOVCHYNA. All rights reserved.
//

import UIKit
import Foundation

class APIController {
    
    var delegate : APITwitterDelegate?
    var token : String = ""
    var foundTweets : [Tweet] = []
    
    init(delegate: APITwitterDelegate?, token: String) {
        self.delegate = delegate
        self.token = token
    }
    
    static func oAuthTwitter(with VC: ViewController) {
        let APIKey = "xDh7xsxMn1FMNCVv44hfOncSy"
        let secretAPIKey = "qkTIi69yI07KQzJ3Gc54TR7WB3Y5poFVGSzO9sls7j8unKOgbX"
        let authString = "https://api.twitter.com/oauth2/token"
        let url = URL(string: authString)
        let bearer = ((APIKey + ":" + secretAPIKey).data(using: String.Encoding.utf8))!.base64EncodedString(options: NSData.Base64EncodingOptions())
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Basic " + bearer, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil { return }
            guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary else { return }
            guard let token = json["access_token"] as? String else {
                DispatchQueue.main.sync {
                    let userInfo: [String : Any] = [ NSLocalizedDescriptionKey :  NSLocalizedString("Authentication", value: "Failed to Authenticate", comment: "") ]
                    VC.tweetError(error: NSError(domain: "https://api.twitter.com/1.1/search/tweets.json", code: 401, userInfo: userInfo))
                }
                return
            }
            VC.APIToken = token
            VC.apiController = APIController(delegate: VC, token: VC.APIToken!)
            VC.apiController?.searchTweets(searchQuery: VC.searchQuery)
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
            if let error = error {
                DispatchQueue.main.sync {
                    let userInfo: [String : Any] = [ NSLocalizedDescriptionKey :  NSLocalizedString("Authentication", value: "Failed to Authenticate", comment: error.localizedDescription) ]
                    self.delegate?.tweetError(error: NSError(domain: "https://api.twitter.com/1.1/search/tweets.json", code: 401, userInfo: userInfo))
                    return
                }
            }
            guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary, let responseTweets = json["statuses"] as? [[String:Any]], responseTweets.count > 0 else {
                DispatchQueue.main.sync {
                    let userInfo: [String : Any] = [ NSLocalizedDescriptionKey :  NSLocalizedString("Empty Result", value: "Search: \(query!) didn't return any results", comment: "") ]
                    self.delegate?.tweetError(error: NSError(domain: "https://api.twitter.com/1.1/search/tweets.json", code: 401, userInfo: userInfo))
                    return
                }
                return
            }
            self.foundTweets.removeAll()
            let dateFormatter = DateFormatter()
            for tweet in responseTweets {
                dateFormatter.dateFormat = "E MMM dd HH:mm:ss Z yyyy"
                let newDate = dateFormatter.date(from: tweet["created_at"] as! String)
                dateFormatter.dateFormat = "DD MMM yyyy h:mm"
                let date = dateFormatter.string(from: newDate!)
                
                let user = tweet["user"] as AnyObject
                let name = user["name"] as! String
                let text = tweet["text"] as! String
                let screenName = user["screen_name"] as! String
                let image = URL(string: user["profile_image_url_https"] as! String)!
                let newTweet = Tweet(name: name, username: "@\(screenName)", text: text, date: date, image: image)
                self.foundTweets.append(newTweet)
            }
            DispatchQueue.main.sync {
                self.delegate?.processTweets(tweets: self.foundTweets)
            }
        }.resume()
    }
}

