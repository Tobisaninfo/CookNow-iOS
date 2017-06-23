//
//  Barcode.swift
//  CookNow
//
//  Created by Tobias on 23.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

class Barcode {
    let name: String
    let amount: Double
    let ingredient: Ingredient?
    
    init(name: String, amount: Double, ingredient: Ingredient? = nil) {
        self.name = name
        self.amount = amount
        self.ingredient = ingredient
    }
    
    class func fromJson(json: JsonObject) -> Barcode? {
        guard let name = json["name"] as? String else {
            return nil
        }
        guard let amount = json["amount"] as? Double else {
            return nil
        }
        guard let ingredinentData = json["ingredient"] as? JsonObject else {
            return Barcode(name: name, amount: amount)
        }
        guard let ingredient = Ingredient.fromJson(jsonData: ingredinentData) else {
            return nil
        }
        return Barcode(name: name, amount: amount, ingredient: ingredient)
    }
}
