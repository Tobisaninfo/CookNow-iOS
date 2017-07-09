//
//  IngredientProperties.swift
//  CookNow
//
//  Created by Tobias on 04.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

/**
 Model for Ingredient Properties. A properties descript an ingredient and is used for the dieatry restriction.
 */
public class IngredientProperty: Comparable {
    
    // MARK: - Cache
    
    /**
     Local, global cache of propeties. Use ```IngredientPropertyHandler``` to get properties.
     */
    public static var properties: [IngredientProperty] = []
    
    // MARK: - Properties
    
    /**
     Property id.
     */
    public let id: Int
    /**
     Property name.
     */
    public let name: String
    
    // Initalizer
    
    /**
     Create a new property.
     - Parameter id: ID
     - Parameter name: Name
     */
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    // MARK: -  Parsing Data
    
    /**
     Parse an ingredient property. If the data is invalid, nil is returned.
     - Parameter jsonData: Json Data
     - Returns: IngredientProperty from Json Data
     */
    public class func fromJson(jsonData: JsonObject) -> IngredientProperty? {
        guard let id = jsonData["id"] as? Int else {
            return nil
        }
        for property in properties {
            if property.id == id {
                return property
            }
        }
        guard let name = jsonData["name"] as? String else {
            return nil
        }
        
        return IngredientProperty(id: id, name: name)
    }
    
    // MARK: - Comparable
    
    /**
     Compare two IngredientProperties by using its id.
     - Returns: ```true``` First id is less than second id
     */
    public static func < (lhs: IngredientProperty, rhs: IngredientProperty) -> Bool {
        return lhs.id < rhs.id
    }
    
    /**
     Compare two IngredientProperties by using its id.
     - Returns: ```true``` Both objects are equal
     */
    public static func == (lhs: IngredientProperty, rhs: IngredientProperty) -> Bool {
        return lhs.id == rhs.id
    }
}
