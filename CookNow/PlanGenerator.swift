//
//  PlanGenerator.swift
//  CookNow
//
//  Created by Tobias on 28.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation
import CoreData

/**
 This class contains methods to generate the weekly plan.
 */
public class PlanGenerator {
    
    /**
     Notification when an plan item was changed. Theobject send with the notification is eather the index of the plan item or -1.
     */
    public static let NewPlanItem = Notification.Name("NewPlanItem")
    
    /**
     Get a random recipe. This method uses network connection to get informationen from the server. It should run in a background thread.
     -
     */
    public class func nextRecipe() -> Recipe? {
        if let currentPlan = PlanItem.list(), let rating = Rating.list() {
            let userProperties = getUserProperties()
            
            // Get all positive recipes
            let recipeList = RecipeHandler.list()
            
            let positivRecipes = recipeList.filter() {
                return !contains(recipe: $0, inPlan: currentPlan) && contains(recipe: $0, inPositiveRating: rating)
            }
            
            if Int(arc4random_uniform(2)) < 1 && positivRecipes.count > 10 {
                if positivRecipes.count > 0 {
                    let randomIndex = Int(arc4random_uniform(UInt32(positivRecipes.count)))
                    let recipe = positivRecipes[randomIndex]
                    return recipe
                } else {
                    Rating.list()?.forEach({ $0.delete() })
                }
            } else {
                // Filter all available recipes
                let possibleRecipes = recipeList.filter() {
                    return !contains(recipe: $0, inPlan: currentPlan)
                        && !contains(recipe: $0, inNegativeRating: rating)
                }
                
                let recipeListFiltered = possibleRecipes.filter({
                    checkProperties(recipe: $0, userProperties: userProperties)
                })
                
                // If not recipe is available, use all recipes unfiltered
                let usedList = recipeListFiltered.count == 0 ? possibleRecipes : recipeListFiltered
                
                if possibleRecipes.count > 0 {
                    let randomIndex = Int(arc4random_uniform(UInt32(usedList.count)))
                    let recipe = usedList[randomIndex]
                    return recipe
                } else {
                    Rating.list()?.forEach({ $0.delete() })
                }
            }
        }
        return nil
    }
    
    /**
     Create a new plan for all 7 days. This method sends a ```NewPlanItem``` notification. This method uses the ```nextRecipe()```method.
     */
    public class func newPlan() {
        if let plan = PlanItem.getCurrentPlan() {
            for item in plan {
                createNewItem(for: item)
            }
            NotificationCenter.default.post(name: NewPlanItem, object: -1)
        }
    }
    
    /**
     Update the recipe for a plan item. This method sends a ```NewPlanItem``` notification. This method uses the ```nextRecipe()```method.
     - Parameter item: Plan Item to update
     - Parameter notification: Sends a ```NewPlanitem``` notification. Default Value is false
     */
    public class func createNewItem(for item: PlanItem, withNotificaiton notification: Bool = false) {
        if let recipe = nextRecipe() {
            item.recipeID = Int32(recipe.id)
            item.name = recipe.name
            
            if notification {
                NotificationCenter.default.post(name: NewPlanItem, object: index)
            }
        }
    }
    
    // MARK: - Getter
    
    /**
     Get the users properties.
     - Returns: List of properties
     */
    private class func getUserProperties() -> [IngredientProperty] {
        var properties = [IngredientProperty]()
        for property in IngredientProperty.properties {
            if UserDefaults.standard.bool(forKey: "Property.\(property.id)") {
                properties.append(property)
            }
        }
        return properties
    }
    
    // MARK: - Check Methods
    
    /**
     Check a recipe against the properties.
     - Parameter recipe
     */
    private class func checkProperties(recipe: Recipe, userProperties: [IngredientProperty]) -> Bool {
        for ingredient in recipe.ingredients {
            for userProperty in userProperties {
                if !ingredient.ingredient.properties.contains(userProperty) {
                    return false
                }
            }
        }
        return true
    }
    
    /**
     Check if a recipe is already in the weekly plan.
     - Parameter recipe: Recipe to test
     - Parameter plan: Current plan.
     - Returns: ```true``` Recipe is in plan.
     */
    private class func contains(recipe: Recipe, inPlan plan: [PlanItem]) -> Bool {
        for item in plan {
            if Int(item.recipeID) == recipe.id {
                return true
            }
        }
        return false
    }
    
    /**
     Check if a recipe is rated negative.
     - Parameter recipe: Recipe to test
     - Parameter rating: List of ratings.
     - Returns: ```true``` Recipe is rated negative.
     */
    private class func contains(recipe: Recipe, inNegativeRating rating: [Rating]) -> Bool {
        for item in rating {
            if Int(item.recipeID) == recipe.id && item.rating < 0 {
                return true
            }
        }
        return false
    }
    
    /**
     Check if a recipe is rated positive.
     - Parameter recipe: Recipe to test
     - Parameter rating: List of ratings.
     - Returns: ```true``` Recipe is rated positive.
     */
    private class func contains(recipe: Recipe, inPositiveRating rating: [Rating]) -> Bool {
        for item in rating {
            if Int(item.recipeID) == recipe.id && item.rating > 0 {
                return true
            }
        }
        return false
    }
}
