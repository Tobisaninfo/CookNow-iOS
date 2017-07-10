//
//  Item.swift
//  CookNow
//
//  Created by Tobias on 05.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation


/**
 An item is a object needed to cook a recipe. They are collected in the ```Step```.
 */
public class Item {
    
    // MARK: - Properties
    
    /**
     Id of the item
     */
    public let id: Int
    /**
     Name of the item
     */
    public let name: String
    
    // MARK: - Initializer
    
    /**
     Create a new item with id and name.
     - Parameter id: Id of the item
     - Parameter name: Name of the item
     */
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    // MARK: - Parsing Data
    
    /**
     Parse an item from json data. If the data is invalid, nil is returned.
     - Parameter jsonData: Json Data
     - Returns: Item from Json Data.
     */
    public class func fromJson(jsonData: HttpUtils.JsonObject) -> Item? {
        guard let name = jsonData["name"] as? String else {
            return nil
        }
        guard let id = jsonData["id"] as? Int else {
            return nil
        }
        return Item(id: id, name: name)
    }
}
