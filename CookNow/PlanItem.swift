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
    
    class func add(recipe: Recipe, index: Int) -> PlanItem? {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            let context = delegate.persistentContainer.viewContext
            if let entity = NSEntityDescription.entity(forEntityName: className, in: context) {
                if let item = NSManagedObject(entity: entity, insertInto: context) as? PlanItem {
                    item.recipeID = Int32(recipe.id)
                    item.order = Int32(index)
                    
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
                return try delegate.persistentContainer.viewContext.fetch(NSFetchRequest(entityName: "PlanItem")) as? [PlanItem]
            } catch {
                print(error)
            }
        }
        return nil
    }
    
    class func getCurrentPlan() -> [PlanItem]? {
        if var plan = list() {
            while plan.count < 7 {
                if let newItem = PlanGenerator.nextRecipe() {
                    plan.append(newItem)
                }
            }
            return plan
        }
        return nil
    }
    
    func delete() {
        CoreDataUtils.delete(object: self)
    }
}
