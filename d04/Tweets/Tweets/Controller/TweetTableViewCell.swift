//
//  TweetTableViewCell.swift
//  Tweets
//
//  Created by Steve Vovchyna on 15.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
