//
//  IngredientPropertyHandler.swift
//  CookNow
//
//  Created by Tobias on 08.07.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

class IngredientPropertyHandler {
    class func list() -> [IngredientProperty] {
        var properties: [IngredientProperty] = []
        
        HttpUtils.get(url: "/properties/", callback: {
            if let jsonData = try? JSONSerialization.jsonObject(with: $0, options: []) as? JsonArray {
                if let json = jsonData {
                    for item in json {
                        if let ingredient = IngredientProperty.fromJson(jsonData: item) {
                            properties.append(ingredient)
                        }
                    }
                }
            }
        })
        
        return properties
    }
}
