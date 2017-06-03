//
//  IgredientUse.swift
//  CookNow
//
//  Created by Tobias on 03.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

class IngredientUse {
    let ingredient: Ingredient
    let amount: Double
    
    init(ingredient: Ingredient, amount: Double) {
        self.ingredient = ingredient
        self.amount = amount
    }
    
    class func fromJson(jsonData: [[String:Any]]) -> [IngredientUse] {
        var ingredients: [IngredientUse] = []
        for data in jsonData {
            if let amount = data["amount"] as? Double {
                if let ingredientData = data["ingredient"] as? [String:Any] {
                    if let ingredient = Ingredient.fromJson(jsonData: ingredientData) {
                        ingredients.append(IngredientUse(ingredient: ingredient, amount: amount))
                    }
                }
            }
        }
        return ingredients
    }
}
