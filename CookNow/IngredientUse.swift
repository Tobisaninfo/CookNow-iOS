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
    let price: Double
    
    init(ingredient: Ingredient, amount: Double, price: Double) {
        self.ingredient = ingredient
        self.amount = amount
        self.price = price
    }
    
    class func fromJson(jsonData: JsonObject) -> IngredientUse? {
        guard let amount = jsonData["amount"] as? Double else {
            return nil
        }
        guard let price = jsonData["price"] as? Double else {
            return nil
        }
        guard let ingredientData = jsonData["ingredient"] as? JsonObject else {
            return nil
        }
        guard let ingredient = Ingredient.fromJson(jsonData: ingredientData) else {
            return nil
        }
        return IngredientUse(ingredient: ingredient, amount: amount, price: price)
    }
}

extension IngredientUse {
    var amountFormatted: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        return formatter.string(from: amount as NSNumber) ?? ""
    }
}
