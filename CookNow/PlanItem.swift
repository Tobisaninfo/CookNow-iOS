//
//  PlanItem.swift
//  CookNow
//
//  Created by Tobias on 28.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation
import CoreData

/**
 Util CoreData methods for the ```PlanItem``` class.
 */
public extension PlanItem {
    private static let className = String(describing: PlanItem.self)
    
    /**
     Add an item to the plan for a day. If the insertion fails, ```nil``` will be returned. The returned object can be modified. The CoreData Context must be saved using the ```AppDelegate```.
     - Parameter day: Number of day (between 1 and 7)
     - Returns: Added PlanItem
     */
    public class func add(day: Int) -> PlanItem? {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            let context = delegate.persistentContainer.viewContext
            if let entity = NSEntityDescription.entity(forEntityName: className, in: context) {
                if let item = NSManagedObject(entity: entity, insertInto: context) as? PlanItem {
                    item.day = Int32(day)
                    item.recipeID = -1
                    
                    delegate.saveContext()
                    
                    return item
                }
            }
        }
        return nil
    }
    
    /**
     List all items in the plan. If the fetch request fails, ```nil``` will be returned.
     - Returns: List of items.
     */
    public class func list() -> [PlanItem]? {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            do {
                return try delegate.persistentContainer.viewContext.fetch(NSFetchRequest(entityName: className)) as? [PlanItem]
            } catch {
                print(error)
            }
        }
        return nil
    }
    
    /**
     List all items in the plan. If the fetch request fails, ```nil``` will be returned. In comparesion to ```list()``` this method add missing days. The result is contains always 7 objects.
     - Returns: List of items.
     */
    public class func getCurrentPlan() -> [PlanItem]? {
        if var plan = list() {
            
            func nextNumber() -> Int {
                var min = 0
                for item in plan {
                    if Int(item.day) == min + 1 {
                        min = min + 1
                    }
                }
                return min + 1
            }
            
            // Add container objects
            while plan.count < 7 {
                if let item = add(day: nextNumber()) {
                    plan.append(item)
                }
            }
            
            // Fill object
            for item in plan {
                if item.isEmpty() {
                    PlanGenerator.createNewItem(for: item)
                }
            }
            
            return plan
        }
        return nil
    }
    
    /**
     Check is a PlanItem contains a recipe.
     - Returns: ```true``` Is Empty (RecipeID == -1)
     */
    public func isEmpty() -> Bool {
        return recipeID == -1
    }
}

/**
 Util methods to bridge the network objects and the core data objects.
 */
extension PlanItem {
    
    /**
     Returns a PlanItem that matches the recipe id.
     - Returns: Macthed PlanItem or ```nil```
     */
    public class func find(recipe: Recipe) -> PlanItem? {
        if let list = list() {
            for item in list {
                if Int(item.recipeID) == recipe.id {
                    return item
                }
            }
        }
        return nil
    }
}
