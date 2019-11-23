//
//  Message.swift
//  Siri
//
//  Created by Steve Vovchyna on 22.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import Foundation

enum UserType {
    case bot
    case user
}

struct Message {
    var user : UserType
    var message : String
    
    init(user: UserType, text: String) {
        self.user = user
        self.message = text
    }
}
