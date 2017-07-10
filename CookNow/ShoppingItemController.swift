//
//  ShoppingItemController.swift
//  CookNow
//
//  Created by Tobias on 29.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation
import CoreData

/**
 This class provides methods to create the shopping list depending on the weekly plan.
 */
public class ShoppingItemController {
    
    /**
     Get the items for the recipes in the weeklply plan, that are not in the pantry. This method uses network connection to get all needed information. It should be run in a background thread.
     - Returns: Shopping Items (already in the CoreData database)
     */
    public class func missingItemsForWeeklyPlan() -> [ShoppingItem] {
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
    
    /**
     Get all missing items for a recipe depending on the pantry items.
     - Returns: Shopping items for the recipe
     */
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
    
    /**
     Clear all items.
     */
    public class func clearShoppingList() {
        ShoppingItem.list()?.forEach({$0.delete()})
    }
    
    /**
     Ground all shopping items into an array of similar items. Each array contains the indiviual shopping items from the recipe.
     - Parameter shoppingItems: List of items to group
     - Returns: Grouped items
     */
    public class func group(shoppingItems: [ShoppingItem]) -> [[ShoppingItem]] {
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
