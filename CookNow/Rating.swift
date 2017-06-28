//
//  Rating.swift
//  CookNow
//
//  Created by Tobias on 28.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation
import CoreData

extension Rating {
    private static let className = String(describing: Rating.self)
    
    class func top(recipe: PlanItem) {
        _ = add(recipe: recipe, rating: 1)
    }
    
    class func flop(recipe: PlanItem) {
        _ = add(recipe: recipe, rating: -1)
    }
    
    private class func add(recipe: PlanItem, rating: Int) -> Rating? {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            let context = delegate.persistentContainer.viewContext
            if let entity = NSEntityDescription.entity(forEntityName: className, in: context) {
                if let item = NSManagedObject(entity: entity, insertInto: context) as? Rating {
                    item.rating = Int32(rating)
                    item.recipeID = recipe.recipeID
                    
                    delegate.saveContext()
                    
                    return item
                }
            }
        }
        return nil
    }
    
    
    class func list() -> [Rating]? {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            do {
                return try delegate.persistentContainer.viewContext.fetch(NSFetchRequest(entityName: className)) as? [Rating]
            } catch {
                print(error)
            }
        }
        return nil
    }
    
    func delete() {
        CoreDataUtils.delete(object: self)
    }
}
