
//
//  ResourceHandler.swift
//  CookNow
//
//  Created by Tobias on 10.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

/**
 Class that provides methods for handling resources like images.
 */
public class ResourceHandler {
    
    /**
     Type of Resource
     */
    public enum Scope {
        /**
         Recipe.
         */
        case recipe
        /**
         Ingredient.
         */
        case ingredient
        /**
         Market
         */
        case market
        
        /**
         Get the url part name of the scope.
         - Returns: Url name
         */
        public func url() -> String {
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

    /**
     Load an image from disk or network.
     - Parameter scope: Type of image
     - Parameter id: Id of the item
     - Parameter handler: Change image before it will returned
     - Returns: Loaded image
     */
    public class func loadImage(scope: Scope, id: Int, handler: ((UIImage?) -> UIImage?)? = nil) -> UIImage? {
        let fileSuffix = scope == .market ? "png" : "jpg"
        
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as String
        let folder = URL(fileURLWithPath: path).appendingPathComponent(scope.url())
        let localUrl = folder.appendingPathComponent("\(id).\(fileSuffix)")
        
        if let data = try? Data(contentsOf: localUrl) {
            var image = UIImage(data: data)
            if let handler = handler {
                image = handler(image)
            }
            return image
        } else {
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
        }
        
        if let host = Bundle.main.infoDictionary?["Host"] as? String {
            if let url = URL(string: host + "/res/\(scope.url())/\(id).\(fileSuffix)") {
                if let data = try? Data(contentsOf: url) {
                    do {
                        try data.write(to: localUrl)
                    } catch {
                        print(error)
                    }
                    print("Load Image: \(url)")
                    var image = UIImage(data: data)
                    if let handler = handler {
                        image = handler(image)
                    }
                    return image
                }
            }
        }
        return nil
    }
 
    class func clear() {
        for scope in iterateEnum(Scope.self) {
            let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as String
            let folder = URL(fileURLWithPath: path).appendingPathComponent(scope.url())
            try? FileManager.default.removeItem(at: folder)
        }
    }
}
