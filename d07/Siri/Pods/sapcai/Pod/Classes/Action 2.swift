//
//  File.swift
//  Pods
//
//  Created by Pierre-Edouard Lieb on 3/30/17.
//
//

import Foundation
import ObjectMapper

open class Action: Mappable {
    
    public var slug: String!
    public var done: Bool!
    public var reply: String!
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    open func mapping(map: Map) {
        slug            <- map["slug"]
        done            <- map["done"]
        reply           <- map["reply"]
    }
}
