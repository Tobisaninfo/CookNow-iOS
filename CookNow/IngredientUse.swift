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
    
    class func fromJson(jsonData: JsonObject) -> IngredientUse? {
        guard let amount = jsonData["amount"] as? Double else {
            return nil
        }
        guard let ingredientData = jsonData["ingredient"] as? JsonObject else {
            return nil
        }
        guard let ingredient = Ingredient.fromJson(jsonData: ingredientData) else {
            return nil
        }
        return IngredientUse(ingredient: ingredient, amount: amount)
    }
}
