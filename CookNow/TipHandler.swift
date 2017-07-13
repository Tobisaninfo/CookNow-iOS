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
}
