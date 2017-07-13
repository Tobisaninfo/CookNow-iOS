//
//  IngredientPropertyHandler.swift
//  CookNow
//
//  Created by Tobias on 08.07.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

/**
 This class contains methods to get information about properties.
 */
public class IngredientPropertyHandler {
    
    /**
     List all available properties.
     - Returns: List of properties
     */
    public class func list() -> [IngredientProperty] {
        var properties: [IngredientProperty] = []
        
        HttpUtils.get(url: "/properties/", callback: {
            if let jsonData = try? JSONSerialization.jsonObject(with: $0, options: []) as? HttpUtils.JsonArray {
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
