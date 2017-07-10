//
//  Market.swift
//  CookNow
//
//  Created by Tobias on 05.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

/**
 Market is type to store information of super markets.
 */
public class Market {
    
    // MARK: - Cache
    
    /**
     Local global cache for markets. Use ```MarketHandler``` to get markets.
     */
    public static var markets: [Market] = []
    
    // MARK: - Properties
    
    /**
     Market ID
     */
    public let id: Int
    /**
     Market Name
     */
    public let name: String
    
    // MARK: - Initializer
    
    /**
     Create a new market.
     - Parameter id: Market ID
     - Parameter name: Market name
     */
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    // MARK: - Parsing Data
    
    /**
     Parse a market from json data. If the data is invalid, nil is returned.
     - Parameter jsonData: Json Data
     - Returns: Market from Json Data
     */
    public class func fromJson(jsonData: JsonObject) -> Market? {
        guard let name = jsonData["name"] as? String else {
            return nil
        }
        guard let id = jsonData["id"] as? Int else {
            return nil
        }
        return Market(id: id, name: name)
    }
}
