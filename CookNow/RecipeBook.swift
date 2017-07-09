//
//  RecipeBook.swift
//  CookNow
//
//  Created by Tobias on 24.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit
import CoreData

/**
 Util CoreData methods for the ```RecipeBook``` class.
 */
extension RecipeBook {
    private static let className = String(describing: RecipeBook.self)
    
    /**
     Add a new RecipeBook. If the insertion fails, ```nil``` will be returned. The returned object can be modified. The CoreData Context must be saved using the ```AppDelegate```.
     - Parameter name: Name of the Book
     - Returns: Added RecipeBook
     */
    public class func add(name: String) -> RecipeBook? {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            let context = delegate.persistentContainer.viewContext
            if let entity = NSEntityDescription.entity(forEntityName: className, in: context) {
                if let item = NSManagedObject(entity: entity, insertInto: context) as? RecipeBook {
                    item.name = name
                
                    delegate.saveContext()
                    
                    return item
                }
            }
        }
        return nil
    }
    
    /**
     Delete a RecipeBook.
     */
    public func delete() {
        CoreDataUtils.delete(object: self)
    }
    
    /**
     List all books. If the fetch request fails, ```nil``` will be returned.
     - Returns: List of books.
     */
    class func list() -> [RecipeBook]? {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            do {
                return try delegate.persistentContainer.viewContext.fetch(NSFetchRequest(entityName: className)) as? [RecipeBook]
            } catch {
                print(error)
            }
        }
        return nil
    }

}
