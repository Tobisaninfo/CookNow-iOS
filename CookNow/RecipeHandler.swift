//
//  RecipeHandler.swift
//  CookNow
//
//  Created by Tobias on 01.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation
import SwiftClient

class RecipeHandler {

    class func getRecipe(id: Int) -> RecipeDetail? {
        let semaphore = DispatchSemaphore.init(value: 0)
        var recipe: RecipeDetail? = nil
        
        if let host = Bundle.main.infoDictionary?["Host"] as? String {
            let client = Client().baseUrl(url: host)
            client.get(url: "/recipe/\(id)")
                .end(done: {res in
                    if (res.basicStatus == .ok) {
                        if let data = res.text?.data(using: .utf8) {
                            do {
                                if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                                    recipe = RecipeDetail.fromJson(jsonData: jsonData)
                                }
                            } catch {
                            }
                        }
                    } else {
                        // Fetch Error
                    }
                    semaphore.signal()
            })
        }
        semaphore.wait()
        
        return recipe
    }
}
