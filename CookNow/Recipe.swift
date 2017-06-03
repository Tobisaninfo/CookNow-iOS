//
//  RecipeDetail.swift
//  CookNow
//
//  Created by Tobias on 01.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

class Recipe {
    
    let name: String
    let description: String
    let steps: [Step]
    let time: Int
    let difficulty: Int
    
    init(name: String, description: String, steps: [Step], time: Int, difficulty: Int) {
        self.name = name
        self.description = description
        self.steps = steps
        self.time = time
        self.difficulty = difficulty
    }
    
    class func fromJson(jsonData: [String: Any]) -> Recipe? {
        guard let name = jsonData["name"] as? String else {
            return nil
        }
        guard let description = jsonData["description"] as? String else {
            return nil
        }
        guard let time = jsonData["time"] as? Int else {
            return nil
        }
        guard let difficulty = jsonData["difficulty"] as? Int else {
            return nil
        }
        
        guard let stepsData = jsonData["steps"] as? [[String:Any]] else {
            return nil
        }
        let steps = Step.formJson(jsonData: stepsData)
        
        return Recipe(name: name, description: description, steps: steps, time: time, difficulty: difficulty)
    }
}
