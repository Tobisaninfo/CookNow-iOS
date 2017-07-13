//
//  TipHandler.swift
//  CookNow
//
//  Created by Tobias on 13.07.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

/**
 This class contains methods to get information about tips.
 */
public class TipHandler {
    
    /**
     List all tips from the server.
     - Returns: List of tips.
     */
    public class func list() -> [Tip] {
        var tips: [Tip] = []
        
        HttpUtils.get(url: "/tip/", callback: {
            if let jsonData = try? JSONSerialization.jsonObject(with: $0, options: []) as? HttpUtils.JsonArray {
                if let json = jsonData {
                    for item in json {
                        if let tip = Tip.fromJson(jsonData: item) {
                            tips.append(tip)
                        }
                    }
                }
            }
        })
        
        return tips
    }
    
    public class func listCategories() -> [Int: String] {
        var tips: [Int:String] = [:]
        
        HttpUtils.get(url: "/tip/category/", callback: {
            if let jsonData = try? JSONSerialization.jsonObject(with: $0, options: []) as? HttpUtils.JsonArray {
                if let json = jsonData {
                    for item in json {
                        guard let id = item["id"] as? Int else {
                            continue
                        }
                        guard let name = item["name"] as? String else {
                            continue
                        }
                        tips[id]  = name
                    }
                }
            }
        })
        
        return tips
    }
}
