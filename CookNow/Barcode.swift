//
//  Barcode.swift
//  CookNow
//
//  Created by Tobias on 23.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

/**
 Contains information of a barcode. That includes the associated ingredient.
 */
public class Barcode {
    
    // MARK: - Properties
    
    /**
     Barcode name.
     */
    public let name: String
    /**
     Ingredient amount.
     */
    public let amount: Double
    /**
     Associated ingredient.
     */
    public let ingredient: Ingredient?
    
    // MARK: - Initializer
    
    /**
     Create a new barcode object.
     - Parameter name: Product name
     - Parameter amount: Amount of the ingredient
     - Parameter ingredient: Associated ingredient. Could be nil
     */
    public init(name: String, amount: Double, ingredient: Ingredient? = nil) {
        self.name = name
        self.amount = amount
        self.ingredient = ingredient
    }
    
    // MARK: - Parsing Data
    
    /**
     Parse a barcode from json data. If the data is invalid, nil is returned.
     - Parameter jsonData: Json Data
     - Returns: Barcode from Json Data
     */
    public class func fromJson(json: JsonObject) -> Barcode? {
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
