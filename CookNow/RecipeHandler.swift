//
//  RecipeHandler.swift
//  CookNow
//
//  Created by Tobias on 01.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

class RecipeHandler {

    private static var cache = [Int:Recipe]()
    
    class func get(id: Int) -> Recipe? {
        if let recipe = cache[id] {
            return recipe
        }
        var recipe: Recipe? = nil
        
        HttpUtils.get(url: "/recipe/\(id)", callback: {
            if let jsonData = try? JSONSerialization.jsonObject(with: $0, options: []) as? JsonObject {
                if let json = jsonData {
                    recipe = Recipe.fromJson(jsonData: json)
                }
            }
        })
        if let recipe = recipe {
            cache[id] = recipe
        }
        return recipe
    }
    
    class func list() -> [Recipe] {
        var recipes: [Recipe] = []
        
        HttpUtils.get(url: "/recipe/", callback: {
            if let jsonData = try? JSONSerialization.jsonObject(with: $0, options: []) as? JsonArray {
                if let json = jsonData {
                    for item in json {
                        if let recipe = Recipe.fromJson(jsonData: item) {
                            recipes.append(recipe)
                        }
                    }
                }
            }
        })
        
        return recipes
    }
}
