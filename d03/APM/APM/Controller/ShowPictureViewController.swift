//
//  ShowPictureViewController.swift
//  APM
//
//  Created by Stepan VOVCHYNA on 12/21/19.
//  Copyright © 2019 Stepan VOVCHYNA. All rights reserved.
//

import UIKit

class ShowPictureViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var onscreenImage : UIImageView?
    var selectedPicture : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onscreenImage = UIImageView(image: selectedPicture)
        scrollView.addSubview(onscreenImage!)
        scrollView.contentSize = (onscreenImage?.frame.size)!
        scrollView.maximumZoomScale = 100
    }
    
    override func viewDidLayoutSubviews() {
        setZoomScale()
    }
    
    func setZoomScale() {
        var minZoom = min(self.view.bounds.size.width / onscreenImage!.bounds.size.width, self.view.bounds.size.height / onscreenImage!.bounds.size.height)
        minZoom = minZoom > 1.0 ? 1.0 : minZoom
        scrollView.minimumZoomScale = minZoom
        scrollView.zoomScale = minZoom
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return onscreenImage
    }
}

