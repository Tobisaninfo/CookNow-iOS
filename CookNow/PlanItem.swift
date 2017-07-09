//
//  PlanItem.swift
//  CookNow
//
//  Created by Tobias on 28.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation
import CoreData

extension PlanItem {
    private static let className = String(describing: PlanItem.self)
    
    class func add(day: Int) -> PlanItem? {
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
    
    
    class func list() -> [PlanItem]? {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            do {
                return try delegate.persistentContainer.viewContext.fetch(NSFetchRequest(entityName: className)) as? [PlanItem]
            } catch {
                print(error)
            }
        }
        return nil
    }
    
    class func getCurrentPlan() -> [PlanItem]? {
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
    
    func isEmpty() -> Bool {
        return recipeID == -1
    }
    
    class func find(recipe: Recipe) -> PlanItem? {
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
