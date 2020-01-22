//
//  Tweet.swift
//  Tweets
//
//  Created by Stepan VOVCHYNA on 12/21/19.
//  Copyright © 2019 Stepan VOVCHYNA. All rights reserved.
//

import Foundation

struct Tweet : CustomStringConvertible {
    var description: String {
        return "\(name): \(text)"
    }
    let name : String
    let username : String
    let text : String
    let date : String
    let image : URL
}
