//
//  Nlp.swift
//
//  Created by Solberg, Eric on 4/16/18.
//

import Foundation
import ObjectMapper

/**
 The Nlp entity contains details about the NLP processing on a request to the Dialog endpoint
 */
public class Nlp : Mappable
{
    public var uuid: String!
    public var source: String!
    public var intents: [Intent]?
    public var act: String!
    public var type: String!
    public var sentiment: String!
    public var entities: [String : Entities]?
    public var language: String!
    public var processing_language: String!
    public var version: String!
    public var timestamp: String!
    public var status: Int!
    
    /**
     Init class map
     */
    required public convenience init?(map: Map)
    {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        uuid                <- map["uuid"]
        source              <- map["source"]
        intents             <- map["intents"]
        act                 <- map["act"]
        type                <- map["type"]
        uuid                <- map["sentiment"]
        entities            <- map["entities"]
        language            <- map["language"]
        processing_language <- map["processing_language"]
        version             <- map["version"]
        timestamp           <- map["timestamp"]
        status              <- map["status"]
    }
}
