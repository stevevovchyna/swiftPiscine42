//
//  Networking.swift
//  APM
//
//  Created by Steve Vovchyna on 21.01.2020.
//  Copyright © 2020 Stepan VOVCHYNA. All rights reserved.
//

import Foundation
import UIKit

enum Result<T> {
    case success(T)
    case failure(String)
}

class Network {
    public var images = ["https://images.unsplash.com/photo-1579192360523-f8f0038c73fb?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=3000&ixlib=rb-1.2.1&q=80&w=4000",
                       "https://images.unsplash.com/photo-1578990628615-3582f6bfa0d4?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=3000&ixlib=rb-1.2.1&q=80&w=4000",
                       "https://images.unsplash.com/photo-1578031519668-4954b2ebfc96?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=3000&ixlib=rb-1.2.1&q=80&w=4000",
                       "https://images.unsplash.com/photo-1578250221161-262ed678b3ca?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=3000&ixlib=rb-1.2.1&q=80&w=4000"]
    
    func getImage(from url: String, completion: @escaping (Result<UIImage>) -> ()) {
        let url = URL(string: url)!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                return completion(.failure(error.localizedDescription))
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                return completion(.failure("Server error"))
            }
            guard let data = data, let image = UIImage(data: data) else { return completion(.failure("There was an issue with the returned data")) }
            completion(.success(image))
        }.resume()
    }
}


