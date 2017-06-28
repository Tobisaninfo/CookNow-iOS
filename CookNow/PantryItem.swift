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
