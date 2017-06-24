//
//  RecipeBook.swift
//  CookNow
//
//  Created by Tobias on 24.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit
import CoreData

extension RecipeBook {
    private static let className = String(describing: RecipeBook.self)
    
    class func add(name: String) -> RecipeBook? {
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
    
    func delete() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            let context = delegate.persistentContainer.viewContext
            context.delete(self)
            delegate.saveContext()
        }
    }
    
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
