//
//  Message.swift
//
//  Created by Solberg, Eric on 4/16/18.
//

import Foundation
import ObjectMapper

/**
 Message entities contain bot responses from a Dialog request
 */
public class Message : Mappable
{
    public var type: String!
    public var content: String!
    
    /**
     Init class map
     */
    required convenience public init?(map: Map)
    {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        type                <- map["type"]
        content             <- map["content"]
    }
}
