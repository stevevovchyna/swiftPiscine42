//
//  Article+CoreDataClass.swift
//  Pods-svovchyn2019_Example
//
//  Created by Steve Vovchyna on 24.11.2019.
//

import Foundation
import CoreData

public class Article : NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }
    
    @NSManaged public var title : String?
    @NSManaged public var content : String?
    @NSManaged public var language : String?
    @NSManaged public var image : NSData?
    @NSManaged public var creationDate : NSDate?
    @NSManaged public var modificationDate : NSDate?
    
    override public var description: String {
        return "This is an article:\n\(title!) in \(language!) language\n\(content!)\ncreated: \(creationDate!) | modified: \(modificationDate!)"
    }    
}
