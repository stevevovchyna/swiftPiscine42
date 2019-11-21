//
//  Conversation.swift
//
//  Created by Solberg, Eric on 4/16/18.
//

import Foundation
import ObjectMapper

/**
 The Conversation entity is a component of the Dialog response
 
 Return from the SAP Conversational AI Dialog API call
 */
public class Conversation : Mappable
{
    public var id: String!
    public var language: String!
    public var memory: [String : [String : Any]]?
    public var skill: String!
    public var skill_occurrences: Int!

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
        id                <- map["id"]
        language          <- map["language"]
        memory            <- map["memory"]
        skill             <- map["skill"]
        skill_occurrences <- map["skill_occurrences"]
    }
}
