//
//  IngredientHandler.swift
//  CookNow
//
//  Created by Tobias on 05.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

class IngredientHanler {
    
    private static var cache: [Int:Ingredient] = [:]
    
    class func getLocal(id: Int) -> Ingredient? {
        return cache[id]
    }
    
    class func get(id: Int) -> Ingredient? {
        if let local = getLocal(id: id) {
            return local
        }
        
        var ingredient: Ingredient? = nil
        
        HttpUtils.get(url: "/ingredient/\(id)", callback: {
            if let jsonData = try? JSONSerialization.jsonObject(with: $0, options: []) as? JsonObject {
                if let json = jsonData {
                    ingredient = Ingredient.fromJson(jsonData: json)
                }
            }
        })
        cache[id] = ingredient
        return ingredient
    }
    
    class func list() -> [Ingredient] {
        var ingredients: [Ingredient] = []
        
        HttpUtils.get(url: "/ingredient/", callback: {
            if let jsonData = try? JSONSerialization.jsonObject(with: $0, options: []) as? JsonArray {
                if let json = jsonData {
                    for item in json {
                        if let recipe = Ingredient.fromJson(jsonData: item) {
                            ingredients.append(recipe)
                        }
                    }
                }
            }
        })
        
        return ingredients
    }
    
    class func barcode(code: String) -> Barcode? {
        var barcode: Barcode? = nil

        HttpUtils.get(url: "/barcode/?ean=\(code)", callback: {
            if let jsonData = try? JSONSerialization.jsonObject(with: $0, options: []) as? JsonObject {
                if let json = jsonData {
                    barcode = Barcode.fromJson(json: json)
                }
            }
        })
        return barcode
    }
}
