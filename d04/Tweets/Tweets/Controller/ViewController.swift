//
//  ViewController.swift
//  Tweets
//
//  Created by Steve Vovchyna on 14.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, APITwitterDelegate {
    
    var token : String?
    var processTweetsController : ProcessTweetsController?
    var foundTweets : [Tweet] = []
    var searchQuery = "swift"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProcessTweetsController.oAuthTwitter(with: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 500.0
    }
    
   
    //MARK:- TableView Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        cell.tweetTextLabel.text = foundTweets[indexPath.row].text
        cell.tweetTextLabel.numberOfLines = 0
        cell.nameLabel.text = foundTweets[indexPath.row].name
        cell.dateLabel.text = foundTweets[indexPath.row].date
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundTweets.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    

    
    //MARK:- Protocol methods
    
    func processTweets(tweets : [Tweet]) {
        DispatchQueue.main.async {
            self.foundTweets = tweets
            self.tableView.reloadData()
        }
    }
    
    func tweetError(error: NSError) {
        let alert = UIAlertController(title: error.userInfo["value"] as? String, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

