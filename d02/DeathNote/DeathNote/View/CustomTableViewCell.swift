//
//  CustomTableViewCell.swift
//  DeathNote
//
//  Created by Steve Vovchyna on 21.01.2020.
//  Copyright © 2020 Stepan VOVCHYNA. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var genView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        genView.layer.cornerRadius = 10
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
