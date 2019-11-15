//
//  Tweet.swift
//  Tweets
//
//  Created by Steve Vovchyna on 14.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import Foundation

struct Tweet : CustomStringConvertible {
    var description: String {
        return "\(name): \(text)"
    }
    let name : String
    let text : String
    let date : String
}