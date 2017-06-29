//
//  ShoppingItem.swift
//  CookNow
//
//  Created by Tobias on 29.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation
import CoreData

extension ShoppingItem {
    
    private static let className = String(describing: ShoppingItem.self)
    
    class func add(id: Int, name: String, amount: Double, unit: Unit) -> ShoppingItem? {
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
    
    func delete() {
        CoreDataUtils.delete(object: self)
    }

    func addToPantry() -> PantryItem? {
        return PantryItem.add(id: Int(id), withAmount: amount)
    }

}
