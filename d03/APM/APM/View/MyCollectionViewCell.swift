//
//  MyCollectionViewCell.swift
//  APM
//
//  Created by Steve Vovchyna on 22.01.2020.
//  Copyright © 2020 Stepan VOVCHYNA. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var theImage: UIImageView!
    
    @IBOutlet weak var activityMonitor: UIActivityIndicatorView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let screenWidth = UIScreen.main.bounds.size.width
        if UIDevice.current.orientation.isLandscape {
            widthConstraint.constant = (screenWidth / 3) - 1
            heightConstraint.constant = (screenWidth / 3) - 1
        } else {
            widthConstraint.constant = (screenWidth / 2) - 1
            heightConstraint.constant = (screenWidth / 2) - 1
        }
    }

}
