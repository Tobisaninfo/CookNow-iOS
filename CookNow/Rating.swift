//
//  Rating.swift
//  CookNow
//
//  Created by Tobias on 28.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation
import CoreData

/**
 Util CoreData methods for the ```Rating``` class.
 */
extension Rating {
    private static let className = String(describing: Rating.self)
    
    /**
     Mark a ```PlanItem``` (recipe) positive.
     - Parameter recipe: PlanItem to rate
     - Returns: Added Rating
     */
    public class func top(recipe: PlanItem) -> Rating? {
        return add(recipe: recipe, rating: 1)
    }
    
    /**
     Mark a ```PlanItem``(recipe) negative.
     - Parameter recipe: PlanItem to rate
     */
    public class func flop(recipe: PlanItem) {
        _ = add(recipe: recipe, rating: -1)
    }
    
    /**
     Add an rating to a PlanItem. If the insertion fails, ```nil``` will be returned. The returned object can be modified. The CoreData Context must be saved using the ```AppDelegate```.
     - Parameter recipe: PlanItem to rate
     - Parameter rating: positive number for posotive rating, genative number for negative rating
     - Returns: Rating object from CoreData context
     */
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
    
    /**
     List all ratings. If the fetch request fails, ```nil``` will be returned.
     - Returns: List of ratings.
     */
    public class func list() -> [Rating]? {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            do {
                return try delegate.persistentContainer.viewContext.fetch(NSFetchRequest(entityName: className)) as? [Rating]
            } catch {
                print(error)
            }
        }
        return nil
    }
    
    /**
     Get a rating by id.
     - Parameter id: Recipe ID
     - Returns: Rating or ```nil```
     */
    public class func get(id: Int) -> Rating? {
        if let list = list() {
            for item in list {
                if item.recipeID == Int32(id) {
                    return item
                }
            }
        }
        return nil
    }
    
    /**
     Delete a rating.
     */
    public func delete() {
        CoreDataUtils.delete(object: self)
    }
}
