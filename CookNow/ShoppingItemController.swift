//
//  ShoppingItemController.swift
//  CookNow
//
//  Created by Tobias on 29.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation
import CoreData

class ShoppingItemController {
    class func missingItemsForWeeklyPlan() -> [ShoppingItem] {
        var shoppingItems: [ShoppingItem] = []
        if let plan = PlanItem.getCurrentPlan(), let pantry = PantryItem.list() {
            for item in plan {
                if let recipe = RecipeHandler.get(id: Int(item.recipeID)) {
                    
                    // Add new shopping items
                    shoppingItems.append(contentsOf: missingItemsForRecipe(recipe: recipe, inPanty: pantry))
                }
            }
        }
        return shoppingItems
    }
    
    private class func missingItemsForRecipe(recipe: Recipe, inPanty pantry: [PantryItem]) -> [ShoppingItem] {
        var shoppingItems: [ShoppingItem] = []
        for ingredient in recipe.ingredients {
            var found = false
            for pantryItem in pantry {
                if Int(pantryItem.ingredientID) == ingredient.ingredient.id {
                    if pantryItem.amount >= ingredient.amount {
                        found = true
                        break
                    }
                }
            }
            if !found {
                // No item with amount in pantry
                if let shoppingItem = ShoppingItem.add(id: ingredient.ingredient.id, name: ingredient.ingredient.name, amount: ingredient.amount, unit: ingredient.ingredient.unit) {
                    shoppingItems.append(shoppingItem)
                }
            }
        }
        return shoppingItems
    }
    
    class func clearUnusedItems(list: [ShoppingItem]) {
        ShoppingItem.list()?.forEach({
            var found = false
            for item in list {
                if item.id == $0.id {
                    found = true
                    break
                }
            }
            if !found {
                $0.delete()
            }
        })
    }
    
    class func clearShoppingList() {
        ShoppingItem.list()?.forEach({$0.delete()})
    }
    
    
    class func group(shoppingItems: [ShoppingItem]) -> [[ShoppingItem]] {
        var result = [[ShoppingItem]]()
        for item in shoppingItems {
            var found = false
            for i in 0..<result.count {
                if result[i][0].id == item.id {
                    result[i].append(item)
                    found = true
                    break
                }
            }
            if !found  {
                result.append([item])
            }
        }

        return result
    }
}
