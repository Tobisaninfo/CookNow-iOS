//
//  RecipeDetail.swift
//  CookNow
//
//  Created by Tobias on 01.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

class Recipe {
    
    let id: Int
    let name: String
    let steps: [Step]
    let time: Int
    let difficulty: Int
    
    init(id: Int, name: String, steps: [Step], time: Int, difficulty: Int) {
        self.id = id
        self.name = name
        self.steps = steps
        self.time = time
        self.difficulty = difficulty
    }
    
    var ingredients: [IngredientUse] {
        return steps.flatMap { return $0.ingredients }
    }
    
    var price: Double {
        let prices = ingredients.map({return $0.price})
        return prices.reduce(0, +)
    }
    
    class func fromJson(jsonData: JsonObject) -> Recipe? {
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
        guard let stepsData = jsonData["steps"] as? JsonArray else {
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
    var priceFormatted: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        return formatter.string(from: price as NSNumber) ?? ""
    }
}
