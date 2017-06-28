//
//  RecipeRef.swift
//  CookNow
//
//  Created by Tobias on 25.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit
import CoreData

extension RecipeRef {
    
    private static let className = String(describing: RecipeRef.self)
    
    class func add(id: Int, name: String, image: UIImage, toBook book: RecipeBook) -> RecipeRef? {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            let context = delegate.persistentContainer.viewContext
            if let entity = NSEntityDescription.entity(forEntityName: className, in: context) {
                if let item = NSManagedObject(entity: entity, insertInto: context) as? RecipeRef {
                    
                    item.id = Int32(id)
                    item.name = name
                    item.recipeBook = book
                    item.image = UIImagePNGRepresentation(image) as NSData?
                    
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
}
