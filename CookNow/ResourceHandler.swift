//
//  ResourceHandler.swift
//  CookNow
//
//  Created by Tobias on 10.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class ResourceHandler {
    
    enum Scope {
        case recipe
        case ingredient
        
        func url() -> String {
            switch self {
            case .recipe:
                return "recipe"
            case .ingredient:
                return "ingredient"
            }
        }
    }
    
    class func loadImage(scope: Scope, id: Int) -> UIImage? {
        if let host = Bundle.main.infoDictionary?["Host"] as? String {
            if let url = URL(string: host + "/res/\(scope.url())/\(id).jpg") {
                if let data = try? Data(contentsOf: url) {
                    return UIImage(data: data)
                }
            }
        }
        return nil
    }
}
