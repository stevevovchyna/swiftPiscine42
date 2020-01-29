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
    }

}
