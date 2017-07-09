//
//  IgredientUse.swift
//  CookNow
//
//  Created by Tobias on 03.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

/**
 This class contains a ingredient and an amount of this ingredient. It is used in ```Step```.
 */
public class IngredientUse {
    
    // MARK: - Properties
    
    /**
     Ingredient Refernce.
     */
    public let ingredient: Ingredient
    /**
     Amount. Unit is stored in ```Ingredient```.
     */
    public let amount: Double
    /**
     Price of the ingredient depends on the amount.
     */
    public let price: Double
    
    // MARK: - Initalizer
    
    /**
     Create a new object.
     - Parameter ingredient: Used Ingredient
     - Parameter amount: Amount of the ingredient
     - Parameter price: Price of the ingredient
     */
    public init(ingredient: Ingredient, amount: Double, price: Double) {
        self.ingredient = ingredient
        self.amount = amount
        self.price = price
    }
    
    // MARK: - Parsing Data
    
    /**
     Parse an ingredient use from json data. If the data is invalid, nil is returned.
     - Parameter jsonData: Json Data
     - Returns: IngredientUse from Json Data
     */
    public class func fromJson(jsonData: JsonObject) -> IngredientUse? {
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
    // MARK: - Formatter
    
    /**
     Format the amount with the local settings
     - Returns: Formatted amount string
     */
    public var amountFormatted: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        return formatter.string(from: amount as NSNumber) ?? ""
    }
}
