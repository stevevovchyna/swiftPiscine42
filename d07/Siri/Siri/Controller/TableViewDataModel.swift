//
//  TableViewDataModel.swift
//  Siri
//
//  Created by Steve Vovchyna on 29.01.2020.
//  Copyright © 2020 Steve Vovchyna. All rights reserved.
//

import Foundation
import UIKit

class TableViewDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    var messagesArray : [Message] = [Message(user: .bot, text: "Hi there! Will be glad to help you with any of your weather requests! Don't hesitate to message me!")]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch messagesArray[indexPath.row].user {
        case .bot:
            let botCell = tableView.dequeueReusableCell(withIdentifier: "customBotMessageCell", for: indexPath) as! CustomBotTableViewCell
            botCell.userMessageLabel.text = messagesArray[indexPath.row].message
            return botCell
        case .user:
            let userCell = tableView.dequeueReusableCell(withIdentifier: "customUserMessageCell", for: indexPath) as! CustomUserTableViewCell
            userCell.userMessageLabel.text = messagesArray[indexPath.row].message
            return userCell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
}
