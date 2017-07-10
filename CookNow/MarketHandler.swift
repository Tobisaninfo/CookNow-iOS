//
//  MarketHandler.swift
//  CookNow
//
//  Created by Tobias on 05.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

/**
 This class contains methods to get information abount markets.
 */
public class MarketHandler {
    
    /**
     Get a market by id.
     - Parameter id: Market id
     - Returns: Market or ```nil```
     */
    public class func get(id: Int) -> Market? {
        for market in list() {
            if market.id == id {
                return market
            }
        }
        return nil
    }
    
    /**
     List all available markets
     - Returns: List of markets.
     */
    public class func list() -> [Market] {
        var markets: [Market] = []
        HttpUtils.get(url: "/market/", callback: {
            if let jsonData = try? JSONSerialization.jsonObject(with: $0, options: []) as? HttpUtils.JsonArray {
                if let json = jsonData {
                    for item in json {
                        if let market = Market.fromJson(jsonData: item) {
                            markets.append(market)
                        }
                    }
                }
            }
        })
        return markets
    }
}
