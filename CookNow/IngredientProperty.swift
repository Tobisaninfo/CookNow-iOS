//
//  IngredientProperties.swift
//  CookNow
//
//  Created by Tobias on 04.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

enum IngredientProperty : Int {
    case Vegan = 1
    case Vegetarian
    
    static func fromJson(jsonData: [String:Any]) -> IngredientProperty? {
        guard let id = jsonData["id"] as? Int else {
            return nil
        }
        return IngredientProperty(rawValue: id)
    }
}
