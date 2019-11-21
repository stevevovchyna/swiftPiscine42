//
//  Intent.swift
//  Pods
//
//  Created by PE on 29/09/2016.
//
//

import Foundation
import ObjectMapper

/**
 Class Response
 
 Return from the SAP Conversational AI API call
 */
public class Intent : Mappable, CustomStringConvertible
{
    public var confidence : Float?
    public var slug : String?

    
    /**
     Init class map
     */
    required public init?(map: Map)
    {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        confidence      <- map["confidence"]
        slug            <- map["slug"]
    }
    
    public var description: String {
        return slug!
    }
}
