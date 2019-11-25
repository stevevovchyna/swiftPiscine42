//
//  DiaryTableViewCell.swift
//  Personal Diary
//
//  Created by Steve Vovchyna on 25.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var dateCreated: UILabel!
    @IBOutlet weak var dateModified: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
