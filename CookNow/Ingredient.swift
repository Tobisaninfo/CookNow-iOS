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
    let properties: [IngredientProperty]
    
    private init(id: Int, name: String, properties: [IngredientProperty]) {
        self.id = id
        self.name = name
        self.properties = properties
    }
    
    private static var cache: [Int: Ingredient] = [:]
    
    class func fromJson(jsonData: [String: Any]) -> Ingredient? {
        guard let id = jsonData["id"] as? Int else {
            return nil
        }
        guard let name = jsonData["name"] as? String else {
            return nil
        }
        guard let propertiesData = jsonData["properties"] as? [[String: Any]] else {
            return nil
        }
        var properties: [IngredientProperty] = []
        for data in propertiesData {
            guard let id = data["id"] as? Int else {
                return nil
            }
            if let property = IngredientProperty(rawValue: id) {
                properties.append(property)
            }
        }
        
        if (cache[id] == nil) {
            cache[id] = Ingredient(id: id, name: name, properties: properties)
        }
        
        return cache[id]
    }
}
