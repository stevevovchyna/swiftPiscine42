//
//  Extensions.swift
//  Tweets
//
//  Created by Steve Vovchyna on 22.01.2020.
//  Copyright © 2020 Stepan VOVCHYNA. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func downloaded(from url: URL) {
        contentMode = .scaleAspectFill
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data) else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
}
