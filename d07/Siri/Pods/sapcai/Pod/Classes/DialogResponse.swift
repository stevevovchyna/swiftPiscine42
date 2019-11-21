//
//  DialogResponse.swift
//
//  Created by Solberg, Eric on 4/16/18.
//

import UIKit
import ObjectMapper
import Alamofire

/**
 The DialogResponse entity is returned from calls to the Dialog endpoint
 */
open class DialogResponse: Mappable {
    
    public var nlp: Nlp!
    public var messages: [Message]!
    public var conversation: Conversation!
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    open func mapping(map: Map) {
        nlp                 <- map["nlp"]
        messages            <- map["messages"]
        conversation        <- map["nlp"]
    }
}

