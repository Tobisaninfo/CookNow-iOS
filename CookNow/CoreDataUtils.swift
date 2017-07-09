//
//  CoreDataUtils.swift
//  CookNow
//
//  Created by Tobias on 28.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation
import CoreData

/**
 Util class for the CoreData Framework.
 */
public class CoreDataUtils {
    
    /**
     Delete an object from the core data database.
     - Parameter object: Object to delete.
     */
    public class func delete(object: NSManagedObject) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            let context = delegate.persistentContainer.viewContext
            context.delete(object)
            delegate.saveContext()
        }
    }
}
