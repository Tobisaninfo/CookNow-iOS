
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
        case market
        
        func url() -> String {
            switch self {
            case .recipe:
                return "recipe"
            case .ingredient:
                return "ingredient"
            case .market:
                return "market"
            }
        }
    }
    
    class func loadImage(scope: Scope, id: Int) -> UIImage? {
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as String
        let folder = URL(fileURLWithPath: path).appendingPathComponent(scope.url())
        let localUrl = folder.appendingPathComponent("\(id).jpg")
        
        if let data = try? Data(contentsOf: localUrl) {
            return UIImage(data: data)
        } else {
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
        }
        
        if let host = Bundle.main.infoDictionary?["Host"] as? String {
            if let url = URL(string: host + "/res/\(scope.url())/\(id).jpg") {
                if let data = try? Data(contentsOf: url) {
                    do {
                        try data.write(to: localUrl)
                    } catch {
                        print(error)
                    }
                    print("Load Image: \(url)")
                    return UIImage(data: data)
                }
            }
        }
        return nil
    }
}
