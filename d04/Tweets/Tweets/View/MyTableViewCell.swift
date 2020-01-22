//
//  MyTableViewCell.swift
//  Tweets
//
//  Created by Steve Vovchyna on 22.01.2020.
//  Copyright © 2020 Stepan VOVCHYNA. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var theImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        theImage.layer.cornerRadius = theImage.frame.size.width / 2
        topView.backgroundColor = #colorLiteral(red: 0.8376570344, green: 0.8434004188, blue: 1, alpha: 0.7626819349)
        bottomView.backgroundColor = #colorLiteral(red: 0.8376570344, green: 0.8434004188, blue: 1, alpha: 0.7626819349)
        topView.layer.cornerRadius = 10
        bottomView.layer.cornerRadius = 10
        topView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        // Configure the view for the selected state
    }
    
}
