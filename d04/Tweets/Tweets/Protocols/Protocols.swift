//
//  Protocols.swift
//  Tweets
//
//  Created by Steve Vovchyna on 22.01.2020.
//  Copyright © 2020 Stepan VOVCHYNA. All rights reserved.
//

import Foundation

protocol APITwitterDelegate {
    func processTweets(tweets : [Tweet])
    func tweetError(error: NSError)
}
