//
//  CustomUserTableViewCell.swift
//  Siri
//
//  Created by Steve Vovchyna on 23.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit

class CustomUserTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageLabel: UIView!
    @IBOutlet weak var userMessageView: UIView!
    @IBOutlet weak var userMessageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userMessageLabel.numberOfLines = 0
        userMessageView.layer.backgroundColor = #colorLiteral(red: 0.6983060804, green: 0.5963864472, blue: 0.7044952152, alpha: 0.6788848459)
        userMessageView.layer.cornerRadius = 10
        userImageLabel.layer.cornerRadius = userImageLabel.frame.size.height / 2
    }

}
