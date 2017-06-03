//
//  RecipeHandler.swift
//  CookNow
//
//  Created by Tobias on 01.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

class RecipeHandler {

    class func getRecipe(id: Int) -> Recipe? {
        var recipe: Recipe? = nil
        
        HttpUtils.get(url: "/recipe/\(id)", callback: {
            if let jsonData = try? JSONSerialization.jsonObject(with: $0, options: []) as? [String:Any] {
                if let json = jsonData {
                    recipe = Recipe.fromJson(jsonData: json)
                }
            }
        })
        return recipe
    }
    
    class func getRecipes() -> [Recipe] {
        var recipes: [Recipe] = []
        
        HttpUtils.get(url: "/recipe/", callback: {
            if let jsonData = try? JSONSerialization.jsonObject(with: $0, options: []) as? [[String:Any]] {
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
