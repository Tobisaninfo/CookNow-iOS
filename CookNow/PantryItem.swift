//
//  PantryItem.swift
//  CookNow
//
//  Created by Tobias on 23.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit
import CoreData

extension PantryItem {
    
    private static let className = String(describing: PantryItem.self)
    
    class func add(id: Int, withAmount amount: Double) -> PantryItem? {
        if let list = list() {
            for item in list {
                if Int(item.ingredientID) == id {
                    item.amount = item.amount + amount
                    
                    if let delegate = UIApplication.shared.delegate as? AppDelegate {
                        delegate.saveContext()
                        return item
                    }
                }
            }
        }
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            let context = delegate.persistentContainer.viewContext
            if let entity = NSEntityDescription.entity(forEntityName: className, in: context) {
                if let item = NSManagedObject(entity: entity, insertInto: context) as? PantryItem {
                    item.ingredientID = Int32(id)
                    item.amount = amount
                    
                    delegate.saveContext()
                    
                    return item
                }
            }
        }
        return nil
    }
    
    func delete(amount: Double) {
        if self.amount <= amount {
            delete()
        } else {
            self.amount = self.amount - amount
            
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.saveContext()
            }
        }
    }
    
    func delete() {
        CoreDataUtils.delete(object: self)
    }
    
    class func list() -> [PantryItem]? {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            do {
                return try delegate.persistentContainer.viewContext.fetch(NSFetchRequest(entityName: className)) as? [PantryItem]
            } catch {
                print(error)
            }
        }
        return nil
    }
}

extension PantryItem {
    class func find(ingredient: Ingredient) -> PantryItem? {
        if let list = list() {
            for item in list {
                if Int(item.ingredientID) == ingredient.id {
                    return item
                }
            }
        }
        return nil
    }
}
