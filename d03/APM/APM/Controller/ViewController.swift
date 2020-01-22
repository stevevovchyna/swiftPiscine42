//
//  ViewController.swift
//  APM
//
//  Created by Stepan VOVCHYNA on 12/21/19.
//  Copyright © 2019 Stepan VOVCHYNA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let networking = Network()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib.init(nibName: "MyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "imageCell")
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumInteritemSpacing = 1
            flowLayout.minimumLineSpacing = 2
        }
    }
}
 
extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    //MARK: - CollectionView methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return networking.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! MyCollectionViewCell
        cell.theImage.image = nil
        cell.activityMonitor.isHidden = false
        cell.activityMonitor.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        cell.backgroundColor = UIColor.white
        
        networking.getImage(from: networking.images[indexPath.row]) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error): self.presentAlert(in: self, with: error)
                case .success(let image): cell.theImage.image = image
                }
                cell.activityMonitor.isHidden = true
                cell.activityMonitor.stopAnimating()
            }
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showImage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ShowPictureViewController
        guard let indexPath = collectionView.indexPathsForSelectedItems else { return }
        let cell = collectionView.cellForItem(at: indexPath[0]) as! MyCollectionViewCell
        guard let image = cell.theImage.image else { presentAlert(in: self, with: "There was an error getting your image"); return }
        destinationVC.selectedPicture = image
    }

}

extension ViewController {
    private func presentAlert(in view: UIViewController, with text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in }))
        view.present(alert, animated: true, completion: nil)
    }
}

