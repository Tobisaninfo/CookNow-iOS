//
//  IngredientProperties.swift
//  CookNow
//
//  Created by Tobias on 04.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

class IngredientProperty {
    
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    static var properties: [IngredientProperty] = []
    
    class func fromJson(jsonData: JsonObject) -> IngredientProperty? {
        guard let id = jsonData["id"] as? Int else {
            return nil
        }
        for property in properties {
            if property.id == id {
                return property
            }
        }
        guard let name = jsonData["name"] as? String else {
            return nil
        }
        
        return IngredientProperty(id: id, name: name)
    }
}
