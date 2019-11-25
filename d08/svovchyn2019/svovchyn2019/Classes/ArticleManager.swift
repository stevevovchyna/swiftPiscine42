//
//  ArticleManager.swift
//  Pods-svovchyn2019_Example
//
//  Created by Steve Vovchyna on 24.11.2019.
//

import Foundation
import CoreData

public class ArticleManager : NSObject {
    
    var context : NSManagedObjectContext
    
    public override init() {
        let bundle = Bundle(identifier: "org.cocoapods.svovchyn2019")
        
        guard let url = bundle?.url(forResource: "article", withExtension: "momd") else { fatalError("Error loading model from the bundle") }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else { fatalError("Couldn't initialize managed object model from set url") }
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        
        if let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            let storageURL = documentURL.appendingPathComponent("svovchyn2019.sqlite")
            
            do {
                try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storageURL, options: nil)
            } catch {
                fatalError("Error adding persistent store \(error)")
            }
        } else {
            fatalError("Error locating storage")
        }
    }
    
    public func newArticle() -> Article {
        return NSEntityDescription.insertNewObject(forEntityName: "Article", into: context) as! Article
    }
    
    func fetchData(predicate : NSPredicate) -> [Article] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        
        fetchRequest.predicate = predicate
        
        do {
            let fetchResult = try context.fetch(fetchRequest) as! [Article]
            return fetchResult
        } catch {
            fatalError("Error fetching data!")
        }
    }
    
    public func getAllArticles() -> [Article] {
        return fetchData(predicate: NSPredicate(value: true))
    }
    
    public func getArticles(withLang lang: String) -> [Article] {
        return fetchData(predicate: NSPredicate(format: "language == %@", lang))
    }
    
    public func getArticles(containString str: String) -> [Article] {
        return fetchData(predicate: NSPredicate(format: "title CONTAINS %@ || content CONTAINS %@", str, str))
    }
    
    public func removeArticle(article : Article) {
        context.delete(article)
    }
    
    public func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Error saving context: \(error)")
            }
        }
    }
    
    
}
