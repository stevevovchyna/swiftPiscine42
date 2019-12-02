//
//  ConverseResponse.swift
//
//  Created by Marcus Ataide on 1/23/17.
//  Copyright © 2017 Math. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire

open class ConverseResponse: Mappable {
    
    static fileprivate let base_url : String = "https://api.cai.tools.sap/v2/"
    static fileprivate let textConverse : String = base_url + "converse"
    
    public var uuid: String!
    public var source: String!
    public var replies: [String]?
    public var action: Action?
    public var next_actions: [Action]?
    public var memory: [String : [String : Any]]?
    public var entities: Entities?
    public var intents: [Intent]?
    public var conversation_token: String!
    public var language: String!
    public var timestamp: String!
    public var version: String!
    public var status: Int!
    public var requestToken : String! = ""
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    open func mapping(map: Map) {
        uuid                <- map["uuid"]
        source              <- map["source"]
        replies             <- map["replies"]
        action              <- map["action"]
        next_actions        <- map["next_actions"]
        memory              <- map["memory"]
        entities            <- map["entities"]
        intents             <- map["intents"]
        conversation_token  <- map["conversation_token"]
        language            <- map["language"]
        timestamp           <- map["timestamp"]
        version             <- map["version"]
        status              <- map["status"]
    }
    
    //************ Methods - Global ************
    
    /**
     Get the first intent
     
     */
    public func reply() -> String? {
        if ((replies?.count) != nil) {
            return replies?[0]
        }
        return (nil)
    }
    
    /**
     Get the first next action
     
     */
    public func nextAction() -> Action? {
        if ((next_actions?.count) != nil) {
            return next_actions?[0]
        }
        return (nil)
    }
    
    /**
     Get memory entity
     
     */
    public func getMemory(entity: String) -> [String : AnyObject]? {
        for (key, _) in memory! {
            if key == entity {
                let json = memory! as [String : AnyObject]
                return json[entity] as? [String : AnyObject]
            }
        }
        return (nil)
    }
    
    /**
     Set memory entity
     
     */
    public func resetMemory(entity: [String : [String : Any]]) -> Void {
        let headers = ["Authorization": "Token " + self.requestToken]
        let parameters = ["conversation_token" : self.conversation_token!, "memory" : entity] as [String : Any] 
        Alamofire.request(ConverseResponse.textConverse, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                print (value)
                break
            case .failure(let error):
                print (error)
                break
            }
        }
    }
    
    /**
     Reset memory entity
     
     */
    public func resetMemory(entity: String) -> Void {
        //Reset all memory
        memory?[entity] = ["" : ""]
        let headers = ["Authorization": "Token " + self.requestToken]
        let parameters = ["conversation_token" : self.conversation_token!, "memory" : memory as Any]
        Alamofire.request(ConverseResponse.textConverse, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                print (value)
                break
            case .failure(let error):
                print (error)
                break
            }
        }
    }
    
    /**
     Reset memory
     
     */
    public func resetMemory() -> Void {
        //Reset all memory
        for _ in memory! {
            _ = ""
        }
        let headers = ["Authorization": "Token " + self.requestToken]
        let parameters = ["conversation_token" : self.conversation_token!, "memory" : memory as Any]
        Alamofire.request(ConverseResponse.textConverse, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                print (value)
                break
            case .failure(let error):
                print (error)
                break
            }
        }
    }
    
    /**
     Reset conversation
     
     */
    public func resetConversation() -> Void {
        let headers = ["Authorization": "Token " + self.requestToken]
        let parameters = ["conversation_token" : self.conversation_token!] as [String : Any]
        Alamofire.request(ConverseResponse.textConverse, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                print (value)
                break
            case .failure(let error):
                print (error)
                break
            }
        }
    }
}

