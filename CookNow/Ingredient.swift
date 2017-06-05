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
    
    let unit: Unit
    let properties: [IngredientProperty]
    
    private init(id: Int, name: String, unit: Unit, properties: [IngredientProperty]) {
        self.id = id
        self.name = name
        self.unit = unit
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
            if let property = IngredientProperty.fromJson(jsonData: data) {
                properties.append(property)
            }
        }
        
        guard let unitData = jsonData["unit"] as? [String: Any] else {
            return nil
        }
        guard let unit = Unit.fromJson(jsonData: unitData) else {
            return nil
        }
        
        if (cache[id] == nil) {
            cache[id] = Ingredient(id: id, name: name, unit: unit, properties: properties)
        }
        
        return cache[id]
    }
}
