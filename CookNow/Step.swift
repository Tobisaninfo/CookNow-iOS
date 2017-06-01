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
    
    class func formJson(jsonData: [[String:Any]]) -> [Step] {
        var steps: [Step] = []
        for data in jsonData {
            if let index = data["id"] as? Int {
                if let order = data["order"] as? Int {
                    if let content = data["content"] as? String {
                        steps.append(Step(id: index, order: order, content: content))
                    }
                }
            }
        }
        steps.sort {$0.order < $1.order }
        return steps
    }
}
