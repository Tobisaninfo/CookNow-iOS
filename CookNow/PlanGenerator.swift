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
    
    static let NewPlanItem = Notification.Name("NewPlanItem")
    
    class func nextRecipe(position: Int) -> PlanItem? {
        let recipeList = RecipeHandler.list()
        if let currentPlan = PlanItem.list(), let rating = rating() {
            
            let positivRecipes = recipeList.filter() {
                return !contains(recipe: $0, inPlan: currentPlan) && contains(recipe: $0, inPositiveRating: rating)
            }
            
            if Int(arc4random_uniform(2)) < 1 && positivRecipes.count > 10 {
                if positivRecipes.count > 0 {
                    let randomIndex = Int(arc4random_uniform(UInt32(positivRecipes.count)))
                    let recipe = positivRecipes[randomIndex]
                    return PlanItem.add(recipe: recipe, order: position)
                } else {
                    Rating.list()?.forEach({ $0.delete() })
                }
            } else {
                let possibleRecipes = recipeList.filter() {
                    return !contains(recipe: $0, inPlan: currentPlan) && !contains(recipe: $0, inNegativeRating: rating)
                }
                if possibleRecipes.count > 0 {
                    let randomIndex = Int(arc4random_uniform(UInt32(possibleRecipes.count)))
                    let recipe = possibleRecipes[randomIndex]
                    return PlanItem.add(recipe: recipe, order: position)
                } else {
                    Rating.list()?.forEach({ $0.delete() })
                }
            }
        }
        return nil
    }
    
    class func newPlan() {
        PlanItem.list()?.forEach({
            let index = Int($0.order)
            $0.delete()
            _ = nextRecipe(position: index)
        })
        NotificationCenter.default.post(name: NewPlanItem, object: nil)
    }
    
    class func createNewItem(for item: PlanItem, withNotificaiton notification: Bool = false) {
        let index = Int(item.order)
        item.delete()
        _ = nextRecipe(position: index)
        
        if notification {
            NotificationCenter.default.post(name: NewPlanItem, object: index)
        }
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
    
    private class func contains(recipe: Recipe, inPositiveRating rating: [Rating]) -> Bool {
        for item in rating {
            if Int(item.recipeID) == recipe.id && item.rating > 0 {
                return true
            }
        }
        return false
    }
}
