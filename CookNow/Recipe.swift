//
//  RecipeDetail.swift
//  CookNow
//
//  Created by Tobias on 01.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

/**
 Model a recipe with steps, ingredients and other information.
 */
public class Recipe {
    
    // MARK: - Properties
    
    /**
     Recipe ID.
     */
    public let id: Int
    /**
     Recipe Name.
     */
    public let name: String
    /**
     Recipe Steps. Contains a manual for cooking and all needed ingredients and items.
     */
    public let steps: [Step]
    /**
     Time in minutes.
     */
    public let time: Int
    /**
     Difficulty between 1 and 3.
     */
    public let difficulty: Int
    
    // MARK: - Initializer
    
    /**
     Create a new Recipe.
     - Parameter id: Recipe ID
     - Parameter name: Recipe Name
     - Parameter steps: Array of Steps
     - Parameter time: Time in minutes
     - Parameter difficulty: Difficulty between 1 and 3
     */
    public init(id: Int, name: String, steps: [Step], time: Int, difficulty: Int) {
        self.id = id
        self.name = name
        self.steps = steps
        self.time = time
        self.difficulty = difficulty
    }
    
    // MARK: - Computed Properties
    
    /**
     Compute the ingredients from all steps.
     - Returns: All ingredients needed for the recipe
     */
    public var ingredients: [IngredientUse] {
        return steps.flatMap { return $0.ingredients }
    }
    
    /**
     Compute the price for all ingredients
     - Returns: Price for ingredients
     */
    public var price: Double {
        let prices = ingredients.map({return $0.price})
        return prices.reduce(0, +)
    }
    
    // MARK: - Parsing Data
    
    /**
     Parse a recipe from json data. If the data is invalid, nil is returned.
     - Parameter jsonData: Json Data
     - Returns: Recipe from Json Data
     */
    public class func fromJson(jsonData: HttpUtils.JsonObject) -> Recipe? {
        // Base Data
        guard let id = jsonData["id"] as? Int else {
            return nil
        }
        guard let name = jsonData["name"] as? String else {
            return nil
        }
        guard let time = jsonData["time"] as? Int else {
            return nil
        }
        guard let difficulty = jsonData["difficulty"] as? Int else {
            return nil
        }
        
        // Steps
        guard let stepsData = jsonData["steps"] as? HttpUtils.JsonArray else {
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

        return Recipe(id: id, name: name, steps: steps, time: time, difficulty: difficulty)
    }
}

extension Recipe {
    // MARK: Formatter
    
    /**
     Format the price with the local currency
     - Returns: Formatted price string
     */
    public var priceFormatted: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        return formatter.string(from: price as NSNumber) ?? ""
    }
}


extension Recipe {
    // MARK: Ingredients
    
    /**
     Removes all ingredients for the recipe from the pantry.
     */
    public func done() {
        for ingredient in ingredients {
            if let pantryItem = PantryItem.find(ingredient: ingredient.ingredient) {
                pantryItem.delete(amount: ingredient.amount)
            }
        }
    }
    
    /**
     Check if all ingredients for the recipe are in the pantry.
     - Returns: ```true``` all ingredients are in the pantry
     */
    public func hasAllIngredients() -> Bool {
        for ingredient in ingredients {
            if ingredient.ingredient.canAddToPantry {
                guard let pantryItem = PantryItem.find(ingredient: ingredient.ingredient) else {
                    return false
                }
                if pantryItem.amount < ingredient.amount {
                    return false
                }
            }
        }
        return true
    }
}
