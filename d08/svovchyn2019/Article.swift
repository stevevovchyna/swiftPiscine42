//
//  Article.swift
//  svovchyn2019
//
//  Created by Steve Vovchyna on 24.11.2019.
//

import Foundation
import CoreData

public class Article : NSManagedObject {
    var Title : String?
    var Content : String?
    var Language : String?
    var Image : NSData?
    var CreationDate : NSDate?
    var ModificationDate : NSDate?
    
    override public var description: String {
        return "This is an article"
    }
}
