//
//  Ingredient.swift
//  CookNow
//
//  Created by Tobias on 03.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

/**
 A ingredient contains a name and its properties.
 */
public class Ingredient {
    
    // MARK: - Properties
    
    /**
     Ingredient ID
     */
    public let id: Int
    /**
     Ingredient name
     */
    public let name: String
    /**
     Ingredient product name (german)
     */
    public let productName: String
    /**
     Unit type of ingredient. This is used in ```IngredientUse``` to give amount a context.
     */
    public let unit: Unit
    /**
     List of properties.
     */
    public let properties: [IngredientProperty]
    
    // MARK: - Initializer
    
    /**
     Create a new ingredient.
     - Parameter id: Ingredient ID
     - Parameter name: Ingredient name
     - Parameter productName: Product name
     - Parameter unit: Unit Type of the ingredient
     - Parameter properties: Properties of the ingredient
     */
    private init(id: Int, name: String, productName: String, unit: Unit, properties: [IngredientProperty]) {
        self.id = id
        self.name = name
        self.productName = productName
        self.unit = unit
        self.properties = properties
    }
    
    // MARK: - Parsing Data
    
    /**
     Local cache for ingredients.
     */
    private static var cache: [Int: Ingredient] = [:]
    
    /**
     Parse an ingredient from json data. If the data is invalid, nil is returned.
     - Parameter jsonData: Json Data
     - Returns: Ingredient from Json Data
     */
    public class func fromJson(jsonData: HttpUtils.JsonObject) -> Ingredient? {
        guard let id = jsonData["id"] as? Int else {
            return nil
        }
        
        if (cache[id] != nil) {
            return cache[id]
        }
        
        guard let name = jsonData["displayname"] as? String else {
            return nil
        }
        guard let productName = jsonData["productname"] as? String else {
            return nil
        }
        guard let propertiesData = jsonData["property"] as? HttpUtils.JsonArray else {
            return nil
        }
        var properties: [IngredientProperty] = []
        for data in propertiesData {
            if let property = IngredientProperty.fromJson(jsonData: data) {
                properties.append(property)
            }
        }
        
        guard let unitData = jsonData["unit"] as? HttpUtils.JsonObject else {
            return nil
        }
        guard let unit = Unit.fromJson(jsonData: unitData) else {
            return nil
        }
    
        cache[id] = Ingredient(id: id, name: name, productName: productName, unit: unit, properties: properties)
        return cache[id]
    }
}

extension Ingredient {
    // MARK: - Offers
    
    /**
     Check is an offer exists for the ingredient. To check this, the name of the offer is matched with the ingredient name. If the score is higher 90%, the ingredient has an offer. To check is offers, the local cache of ```MarketOffer.offers``` is used.
     - Returns: ```true``` is the score is greater than 90%
     */
    public func hasOffer() -> Bool {
        var isOffer = false
        for offer in MarketOffer.offers {
            for word in offer.name.components(separatedBy: " ") {
                if (word as NSString).scoreAgainst(productName) > 0.9 {
                    isOffer = true
                }
            }
        }
        return isOffer
    }
}
