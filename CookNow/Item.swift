//
//  Item.swift
//  CookNow
//
//  Created by Tobias on 05.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

class Item {
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    class func fromJson(jsonData: [String: Any]) -> Item? {
        guard let name = jsonData["name"] as? String else {
            return nil
        }
        guard let id = jsonData["id"] as? Int else {
            return nil
        }
        return Item(id: id, name: name)
    }
}
