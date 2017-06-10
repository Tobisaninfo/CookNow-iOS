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
        var image: UIImage? = nil
        HttpUtils.get(url: "/\(scope.url())/\(id))", callback: {
            image = UIImage(data: $0)
        })
        return image
    }
}
