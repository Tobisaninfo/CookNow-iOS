//
//  RecipeHandler.swift
//  CookNow
//
//  Created by Tobias on 01.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

/**
 This class contains methods to get information abount recipes.
 */
public class RecipeHandler {

    /**
     Local recipe cache.
     */
    private static var cache = [Int:Recipe]()
    
    /**
     Get a recipe from the server. If available, the local cache is used.
     - Parameter id: Recipe id
     - Parameter fetch: Fetch the information from the server. The default value is false
     */
    public class func get(id: Int, fetch: Bool = false) -> Recipe? {
        if let recipe = cache[id], !fetch {
            return recipe
        }
        var recipe: Recipe? = nil
        
        HttpUtils.get(url: "/recipe/\(id)", callback: {
            if let jsonData = try? JSONSerialization.jsonObject(with: $0, options: []) as? HttpUtils.JsonObject {
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
    
    /**
     List all recipes that uses an ingredient.
     - Parameter ingredientID: Ingredient id
     - Returns: List of Recipes
     */
    public class func list(ingredientID: Int) -> [Recipe] {
        var recipes: [Recipe] = []
        
        HttpUtils.get(url: "/recipe/?ingredient=\(ingredientID)", callback: {
            if let jsonData = try? JSONSerialization.jsonObject(with: $0, options: []) as? HttpUtils.JsonArray {
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
    
    /**
     List all recipes from the server.
     - Returns: List of recipes.
     */
    public class func list() -> [Recipe] {
        var recipes: [Recipe] = []
        
        HttpUtils.get(url: "/recipe/", callback: {
            if let jsonData = try? JSONSerialization.jsonObject(with: $0, options: []) as? HttpUtils.JsonArray {
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
