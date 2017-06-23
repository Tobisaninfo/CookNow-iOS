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
    
    class func add(id: Int, withAmount amount: Double) -> PantryItem? {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            let context = delegate.persistentContainer.viewContext
            if let entity = NSEntityDescription.entity(forEntityName: "PantryItem", in: context) {
                if let item = NSManagedObject(entity: entity, insertInto: context) as? PantryItem {
                    item.ingredientID = Int32(id)
                    item.amount = amount
                }
            }
        }
        return nil
    }
}
