//
//  Step.swift
//  CookNow
//
//  Created by Tobias on 01.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

class Step {
    
    let id: Int
    let order: Int
    let content: String
    
    init(id: Int, order: Int, content: String) {
        self.id = id
        self.order = order
        self.content = content
    }
    
    class func formJson(jsonData: [String:Any]) -> Step? {
        guard let id = jsonData["id"] as? Int else {
            return nil
        }
        guard let order = jsonData["order"] as? Int else {
            return nil
        }
        guard let content = jsonData["content"] as? String else {
            return nil
        }
        return Step(id: id, order: order, content: content)
    }
}
