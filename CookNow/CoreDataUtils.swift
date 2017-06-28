//
//  CoreDataUtils.swift
//  CookNow
//
//  Created by Tobias on 28.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation
import CoreData

class CoreDataUtils {
    class func delete(object: NSManagedObject) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            let context = delegate.persistentContainer.viewContext
            context.delete(object)
            delegate.saveContext()
        }
    }
}
