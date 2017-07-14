//
//  ShoppingItem.swift
//  CookNow
//
//  Created by Tobias on 29.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation
import CoreData

/**
 Util CoreData methods for the ```ShoppingItem``` class.
 */
extension ShoppingItem {
    
    private static let className = String(describing: ShoppingItem.self)
    
    /**
     Add a shopping item to the database. If the insertion fails, ```nil``` will be returned. The returned object can be modified. The CoreData Context must be saved using the ```AppDelegate```.
     - Parameter id: Ingredient ID
     - Parameter name: Ingredient Name
     - Parameter amount: Amount
     - Parameter unit: Unittype of the amount
     - Returns: Added Shopping Item
     */
    public class func add(id: Int, name: String, amount: Double, unit: Unit) -> ShoppingItem? {
        // Check if exists
        if let list = list() {
            for item in list {
                if Int(item.id) == id && item.amount == amount {
                    return item
                }
            }
        }
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            let context = delegate.persistentContainer.viewContext
            if let entity = NSEntityDescription.entity(forEntityName: className, in: context) {
                if let item = NSManagedObject(entity: entity, insertInto: context) as? ShoppingItem {
                    
                    item.id = Int32(id)
                    item.name = name
                    item.amount = amount
                    item.unit = Int32(unit.rawValue)
                    
                    delegate.saveContext()
                    
                    return item
                }
            }
        }
        return nil
    }

    /**
     List all shopping items. If the fetch request fails, ```nil``` will be returned.
     - Returns: List of shopping items.
     */
    class func list() -> [ShoppingItem]? {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            do {
                return try delegate.persistentContainer.viewContext.fetch(NSFetchRequest(entityName: className)) as? [ShoppingItem]
            } catch {
                print(error)
            }
        }
        return nil
    }
    
    /**
     Delete a shopping item.
     */
    func delete() {
        CoreDataUtils.delete(object: self)
    }

    /**
     Convert a shopping item into a ```PantryItem``` and add it into the pantry.
     - Returns: Added PantryItem
     */
    func addToPantry() -> PantryItem? {
        if let unit = Unit(rawValue: Int(unit)), let name = name {
            return PantryItem.add(Int(id), name: name, unit: unit, amount: amount)
        }
        return nil
    }

}
