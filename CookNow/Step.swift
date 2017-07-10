//
//  Step.swift
//  CookNow
//
//  Created by Tobias on 01.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

/**
 A step is a part of an ```Recipe``` and descripts the ingredients, items and manual.
 */
public class Step {
    
    // MARK: - Properties
    
    /**
     Step id.
     */
    public let id: Int
    /**
     Number of step in recipe.
     */
    public let order: Int
    /**
     Description of the step.
     */
    public let content: String
    
    /**
     List of ingredients for the step.
     */
    public let ingredients: [IngredientUse]
    /**
     List of items used for the step.
     */
    public let items: [Item]
    
    // MARK: - Initializer
    
    /**
     Create a new step using the data.
     - Parameter id: Step id
     - Parameter order: Number of step in recipe
     - Parameter content: Description of the step
     - Parameter ingredients: List of ingredients
     - Parameter items: List of items
     */
    public init(id: Int, order: Int, content: String, ingredients: [IngredientUse], items: [Item]) {
        self.id = id
        self.order = order
        self.content = content
        self.ingredients = ingredients
        self.items = items
    }
    
    // MARK: - Parsing Data
    
    /**
     Parse a step from json data. If the data is invalid, nil is returned.
     - Parameter jsonData: Json Data 
     - Returns: Step from Json Data.
     */
    public class func formJson(jsonData: HttpUtils.JsonObject) -> Step? {
        guard let id = jsonData["id"] as? Int else {
            return nil
        }
        guard let order = jsonData["order"] as? Int else {
            return nil
        }
        guard let content = jsonData["content"] as? String else {
            return nil
        }
        // Items
        guard let itemsData = jsonData["items"] as? HttpUtils.JsonArray else {
            return nil
        }
        var items: [Item] = []
        for i in itemsData {
            if let item = Item.fromJson(jsonData: i) {
                items.append(item)
            }
        }
        
        // Ingredients
        guard let ingredientData = jsonData["ingredients"] as? HttpUtils.JsonArray else {
            return nil
        }
        var ingredients: [IngredientUse] = []
        for item in ingredientData {
            if let ingredientUse = IngredientUse.fromJson(jsonData: item) {
                ingredients.append(ingredientUse)
            }
        }
        
        return Step(id: id, order: order, content: content, ingredients: ingredients, items: items)
    }
}
