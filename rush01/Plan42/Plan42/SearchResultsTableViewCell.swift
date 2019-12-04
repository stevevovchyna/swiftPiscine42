//
//  SearchResultsTableViewCell.swift
//  Plan42
//
//  Created by Steve Vovchyna on 04.12.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleCellLabel: UILabel!
    @IBOutlet weak var detailCellLabel: UILabel!
    @IBOutlet weak var myImageLabel: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        self.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 0.9)
    }

    
}
