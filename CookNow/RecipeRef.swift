//
//  RecipeRef.swift
//  CookNow
//
//  Created by Tobias on 25.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit
import CoreData

/**
 Util CoreData methods for the ```RecipeRef``` class.
 */
extension RecipeRef {
    
    private static let className = String(describing: RecipeRef.self)
    
    /**
     Add a recipe reference to a RecipeBook. If the insertion fails, ```nil``` will be returned. The returned object can be modified. The CoreData Context must be saved using the ```AppDelegate```.
     - Parameter id: Recipe ID
     - Parameter name: Name of the recipe
     - Parameter image: Recipe Image
     - Parameter book: Recipe Book to add
     - Returns: Added RecipeRef
     */
    public class func add(id: Int, name: String, image: UIImage, toBook book: RecipeBook) -> RecipeRef? {
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

    /**
     Delete a RecipeBook from the pantry.
     */
    public func delete() {
        CoreDataUtils.delete(object: self)
    }
}
