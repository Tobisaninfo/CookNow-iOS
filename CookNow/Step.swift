//
//  Step.swift
//  CookNow
//
//  Created by Tobias on 01.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

class Step {
    
    let id: Int
    let order: Int
    let content: String
    
    let ingredients: [IngredientUse]
    
    let items: [Item]
    
    init(id: Int, order: Int, content: String, ingredients: [IngredientUse], items: [Item]) {
        self.id = id
        self.order = order
        self.content = content
        self.ingredients = ingredients
        self.items = items
    }
    
    class func formJson(jsonData: JsonObject) -> Step? {
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
        guard let itemsData = jsonData["items"] as? JsonArray else {
            return nil
        }
        var items: [Item] = []
        for i in itemsData {
            if let item = Item.fromJson(jsonData: i) {
                items.append(item)
            }
        }
        
        // Ingredients
        guard let ingredientData = jsonData["ingredients"] as? JsonArray else {
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
