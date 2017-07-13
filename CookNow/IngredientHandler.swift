//
//  IngredientHandler.swift
//  CookNow
//
//  Created by Tobias on 05.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

/**
 This class contains methods to get information about ingredients.
 */
public class IngredientHanler {
    
    /**
     Local cache for ingredients.
     */
    private static var cache: [Int:Ingredient] = [:]
    
    /**
     Get an ingredient from the local cache.
     - Parameter id: Ingredient ID
     - Returns: Ingredient or ```nil```
     */
    public class func getLocal(id: Int) -> Ingredient? {
        return cache[id]
    }
    
    /**
     Get an ingredient from the server or cache.
     - Parameter id: Ingredient ID
     - Returns: Ingredient or ```nil```
     */
    public class func get(id: Int, fetch: Bool = false) -> Ingredient? {
        if let local = getLocal(id: id), !fetch {
            return local
        }
        
        var ingredient: Ingredient? = nil
        
        HttpUtils.get(url: "/ingredient/\(id)", callback: {
            if let jsonData = try? JSONSerialization.jsonObject(with: $0, options: []) as? HttpUtils.JsonObject {
                if let json = jsonData {
                    ingredient = Ingredient.fromJson(jsonData: json)
                }
            }
        })
        cache[id] = ingredient
        return ingredient
    }
    
    /**
     List all ingredients.
     - Returns: List of ingredients.
     */
    public class func list() -> [Ingredient] {
        var ingredients: [Ingredient] = []
        
        HttpUtils.get(url: "/ingredient/", callback: {
            if let jsonData = try? JSONSerialization.jsonObject(with: $0, options: []) as? HttpUtils.JsonArray {
                if let json = jsonData {
                    for item in json {
                        if let ingredient = Ingredient.fromJson(jsonData: item) {
                            ingredients.append(ingredient)
                        }
                    }
                }
            }
        })
        
        return ingredients
    }
    
    public class func barcode(code: String) -> Barcode? {
        var barcode: Barcode? = nil

        HttpUtils.get(url: "/barcode/?ean=\(code)", callback: {
            if let jsonData = try? JSONSerialization.jsonObject(with: $0, options: []) as? HttpUtils.JsonObject {
                if let json = jsonData {
                    barcode = Barcode.fromJson(json: json)
                }
            }
        })
        return barcode
    }
}
