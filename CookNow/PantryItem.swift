//
//  PantryItem.swift
//  CookNow
//
//  Created by Tobias on 23.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit
import CoreData

/**
 Util CoreData methods for the ```PantryItem``` class.
 */
extension PantryItem {
    
    private static let className = String(describing: PantryItem.self)
    
    /**
     Add an item to the pantry with an amount. If the insertion fails, ```nil``` will be returned. The returned object can be modified. The CoreData Context must be saved using the ```AppDelegate```.
     - Parameter ingredient: Ingredient
     - Parameter amount: Amount of the ingredient
     - Returns: Added PantryItem
     */
    public class func add(ingredient: Ingredient, withAmount amount: Double) -> PantryItem? {
        return add(ingredient.id, name: ingredient.name, unit: ingredient.unit, amount: amount)
    }
    
    /**
     Add an item to the pantry with an amount. If the insertion fails, ```nil``` will be returned. The returned object can be modified. The CoreData Context must be saved using the ```AppDelegate```.
     - Parameter id: Ingredient ID
     - Parameter name: Ingredient name
     - Parameter unit: Unit Type of ingredient
     - Parameter amount: Amount of the ingredient
     - Returns: Added PantryItem
     */
    public class func add(_ id: Int, name: String, unit: Unit, amount: Double) -> PantryItem?{
        if let list = list() {
            // Add amount to existing object
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
        
        // Create new object
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            let context = delegate.persistentContainer.viewContext
            if let entity = NSEntityDescription.entity(forEntityName: className, in: context) {
                if let item = NSManagedObject(entity: entity, insertInto: context) as? PantryItem {
                    item.ingredientID = Int32(id)
                    item.amount = amount
                    item.unit = Int32(unit.rawValue)
                    item.name = name
                    
                    delegate.saveContext()
                    
                    return item
                }
            }
        }
        return nil
    }
    
    /**
     Delete an amount from this PantryItem. If the amount is the total amount in the pantry, the hole item will be deleted.
     - Parameter amount: Amount to delete
     */
    public func delete(amount: Double) {
        if self.amount <= amount {
            delete()
        } else {
            self.amount = self.amount - amount
            
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.saveContext()
            }
        }
    }
    
    /**
     Delete an item from the pantry.
     */
    public func delete() {
        CoreDataUtils.delete(object: self)
    }
    
    /**
     List all items in the pantry. If the fetch request fails, ```nil``` will be returned.
     - Returns: List of items.
     */
    public class func list() -> [PantryItem]? {
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

/**
 Util methods to bridge the network objects and the core data objects.
 */
extension PantryItem {
    
    /**
     Returns a PantryItem that matches the ingredient id.
     - Returns: Macthed PantryItem or ```nil```
     */
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

extension PantryItem {
    // MARK: - Formatter
    
    /**
     Format the amount with the local settings
     - Returns: Formatted amount string
     */
    public var amountFormatted: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        return formatter.string(from: amount as NSNumber) ?? ""
    }
}
