//
//  PlanGenerator.swift
//  CookNow
//
//  Created by Tobias on 28.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation
import CoreData

class PlanGenerator {
    
    class func nextRecipe() -> PlanItem? {
        let recipeList = RecipeHandler.list()
        if let currentPlan = PlanItem.list(), let rating = rating() {
            let possibleRecipes = recipeList.filter() {
                return !contains(recipe: $0, inPlan: currentPlan) && !contains(recipe: $0, inNegativeRating: rating)
            }
            let randomIndex = Int(arc4random_uniform(UInt32(possibleRecipes.count)))
            let recipe = possibleRecipes[randomIndex]
            return PlanItem.add(recipe: recipe, index: recipeList.count)
        }
        return nil
    }
    
    private class func rating() -> [Rating]? {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            do {
                return try delegate.persistentContainer.viewContext.fetch(NSFetchRequest(entityName: "Rating")) as? [Rating]
            } catch {
                print(error)
            }
        }
        return nil
    }
    
    private class func contains(recipe: Recipe, inPlan plan: [PlanItem]) -> Bool {
        for item in plan {
            if Int(item.recipeID) == recipe.id {
                return true
            }
        }
        return false
    }
    
    private class func contains(recipe: Recipe, inNegativeRating rating: [Rating]) -> Bool {
        for item in rating {
            if Int(item.recipeID) == recipe.id && item.rating < 0 {
                return true
            }
        }
        return false
    }
}
