//
//  ViewController.swift
//  Tweets
//
//  Created by Stepan VOVCHYNA on 12/21/19.
//  Copyright © 2019 Stepan VOVCHYNA. All rights reserved.
//

import UIKit

class ViewController: UIViewController, APITwitterDelegate {
    
    var APIToken : String?
    var apiController : APIController?
    var foundTweets : [Tweet] = []
    var searchQuery = "school 42"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.text = searchQuery
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: "tweetCell")
        APIController.oAuthTwitter(with: self)
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func performSearch(_ sender: UITextField) {
        searchQuery = searchField.text!
        searchField.resignFirstResponder()
        APIController.oAuthTwitter(with: self)
    }
}

//MARK:- TableView Methods
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! MyTableViewCell
        cell.tweetLabel.text = foundTweets[indexPath.row].text
        cell.nameLabel.text = "\(foundTweets[indexPath.row].name)\n\(foundTweets[indexPath.row].username)"
        cell.dateLabel.text = foundTweets[indexPath.row].date
        cell.theImage.downloaded(from: foundTweets[indexPath.row].image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundTweets.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK:- Protocol methods
extension ViewController {
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

