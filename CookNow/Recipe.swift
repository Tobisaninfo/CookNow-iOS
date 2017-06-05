//
//  RecipeDetail.swift
//  CookNow
//
//  Created by Tobias on 01.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

class Recipe {
    
    let name: String
    let description: String
    
    let steps: [Step]
    let items: [Item]
    
    let ingredients: [IngredientUse]
    
    let time: Int
    let difficulty: Int
    
    init(name: String, description: String, steps: [Step], items: [Item], ingredients: [IngredientUse], time: Int, difficulty: Int) {
        self.name = name
        self.description = description
        self.steps = steps
        self.items = items
        self.ingredients = ingredients
        self.time = time
        self.difficulty = difficulty
    }
    
    class func fromJson(jsonData: [String: Any]) -> Recipe? {
        // Base Data
        guard let name = jsonData["name"] as? String else {
            return nil
        }
        guard let description = jsonData["description"] as? String else {
            return nil
        }
        guard let time = jsonData["time"] as? Int else {
            return nil
        }
        guard let difficulty = jsonData["difficulty"] as? Int else {
            return nil
        }
        
        // Steps
        guard let stepsData = jsonData["steps"] as? [[String:Any]] else {
            return nil
        }
        var steps: [Step] = []
        for item in stepsData {
            if let step = Step.formJson(jsonData: item) {
                steps.append(step)
            }
        }
        // Sort steps into right order
        steps.sort {$0.order < $1.order }
        
        // Items
        guard let itemsData = jsonData["items"] as? [[String:Any]] else {
            return nil
        }
        var items: [Item] = []
        for i in itemsData {
            if let item = Item.fromJson(jsonData: i) {
                items.append(item)
            }
        }
        
        // Ingredients
        guard let ingredientData = jsonData["ingredients"] as? [[String:Any]] else {
            return nil
        }
        var ingredients: [IngredientUse] = []
        for item in ingredientData {
            if let ingredientUse = IngredientUse.fromJson(jsonData: item) {
                ingredients.append(ingredientUse)
            }
        }

        return Recipe(name: name, description: description, steps: steps, items: items, ingredients: ingredients, time: time, difficulty: difficulty)
    }
}
