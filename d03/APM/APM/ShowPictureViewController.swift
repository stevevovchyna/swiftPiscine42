//
//  ShowPictureViewController.swift
//  APM
//
//  Created by Steve Vovchyna on 13.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit

class ShowPictureViewController: UIViewController, UIScrollViewDelegate {
    

    @IBOutlet weak var scrollView: UIScrollView!

    var onscreenImage : UIImageView?
    
    var image = UIImage()
    
    var selectedPicture : MyCollectionViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onscreenImage = UIImageView(image: selectedPicture?.cellImageView.image)
        scrollView.addSubview(onscreenImage!)
        scrollView.contentSize = (onscreenImage?.frame.size)!
        scrollView.maximumZoomScale = 100
    }
    
    override func viewDidLayoutSubviews() {
        setZoomScale()
    }
    
    func setZoomScale() {
        
        var minZoom = min(self.view.bounds.size.width / onscreenImage!.bounds.size.width, self.view.bounds.size.height / onscreenImage!.bounds.size.height)
        if (minZoom > 1.0) {
            minZoom = 1.0
        }
        scrollView.minimumZoomScale = minZoom
        scrollView.zoomScale = minZoom
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return onscreenImage
    }
}

