//
//  ViewController.swift
//  APM
//
//  Created by Steve Vovchyna on 13.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var imagesArray = ["https://wallpaperplay.com/walls/full/d/9/b/44840.jpg", "https://www.nasa.gov/sites/default/files/styles/full_width_feature/public/thumbnails/image/ssc2006-02a_0.jpg", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSC2-oRt0QQ8-blmGQnmGnDLeI9jEhepFeCoo7WMNwO8Ku_9aW2Tw&s",
    "https://www.nasa.gov/sites/default/files/styles/full_width_feature/public/thumbnails/image/49002058586_3ad9f42d8c_k.jpg",
    "https://images.unsplash.com/photo-1520901157462-0ea3fb2f9024?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max",
    "https://images.wallpapersden.com/image/download/small-memory_58461_3840x2160.jpg"]
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - CollectionView methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imagesArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! MyCollectionViewCell
        cell.activityMonitor.startAnimating()
UIApplication.shared.isNetworkActivityIndicatorVisible = true
        cell.backgroundColor = UIColor.white
        
        let pictureURL = URL(string: imagesArray[indexPath.row])!
        let session = URLSession(configuration: .default)
        let downloadPicTask = session.dataTask(with: pictureURL) { (data, response, error) in
            if let e = error {
                print("Error downloading picture: \(e)")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in }))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                if let res = response as? HTTPURLResponse {
                    print("Downloaded picture with response code \(res.statusCode)")
                    if let imageData = data {
                        DispatchQueue.main.async {
                            cell.activityMonitor.stopAnimating()
                            cell.activityMonitor.isHidden = true
                            cell.cellImageView.image = UIImage(data: imageData)
                        }
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        downloadPicTask.resume()
        return cell
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showImage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ShowPictureViewController
        if let indexPath = collectionView.indexPathsForSelectedItems {
            let cell = collectionView.cellForItem(at: indexPath[0]) as! MyCollectionViewCell
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath[0]) as! MyCollectionViewCell
            if cell.cellImageView.image != nil {
                destinationVC.selectedPicture = collectionView.cellForItem(at: indexPath[0]) as? MyCollectionViewCell
            } else {
                let alert = UIAlertController(title: "Error", message: "There was an error getting your image", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

}

extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: (self.view.frame.size.width / 2) - 10, height: (self.view.frame.size.width / 2) - 10)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
    }
}

