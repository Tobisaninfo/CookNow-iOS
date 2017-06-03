//
//  Ingredient.swift
//  CookNow
//
//  Created by Tobias on 03.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

class Ingredient {
    let id: Int
    let name: String
    
    private init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    private static var cache: [Int: Ingredient] = [:]
    
    class func fromJson(jsonData: [String: Any]) -> Ingredient? {
        guard let id = jsonData["id"] as? Int else {
            return nil
        }
        guard let name = jsonData["name"] as? String else {
            return nil
        }
        
        if (cache[id] == nil) {
            cache[id] = Ingredient(id: id, name: name)
        }
        
        return cache[id]
    }
}
