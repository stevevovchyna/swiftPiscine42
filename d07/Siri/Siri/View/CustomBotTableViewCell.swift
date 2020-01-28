//
//  CustomBotTableViewCell.swift
//  Siri
//
//  Created by Steve Vovchyna on 22.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit

class CustomBotTableViewCell: UITableViewCell {

    @IBOutlet weak var userPicView: UIView!
    @IBOutlet weak var userMessageView: UIView!
    @IBOutlet weak var userMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userMessageLabel.numberOfLines = 0
        userMessageView.layer.backgroundColor = #colorLiteral(red: 0.5271991709, green: 0.7516028796, blue: 0.4997833824, alpha: 0.5938570205)
        userMessageView.layer.cornerRadius = 10
        userPicView.layer.cornerRadius = userPicView.frame.size.height / 2
    }
    
}
