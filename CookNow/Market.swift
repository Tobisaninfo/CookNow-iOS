//
//  Market.swift
//  CookNow
//
//  Created by Tobias on 05.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

class Market {
    
    static var markets: [Market] = []
    
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    class func fromJson(jsonData: JsonObject) -> Market? {
        guard let name = jsonData["name"] as? String else {
            return nil
        }
        guard let id = jsonData["id"] as? Int else {
            return nil
        }
        return Market(id: id, name: name)
    }
}
