//
//  MarketOffer.swift
//  CookNow
//
//  Created by Tobias on 05.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

class MarketOffer {
    let name: String
    let price: Double
    let expires: Date
    
    init(name: String, price: Double, expires: Date) {
        self.name = name
        self.price = price
        self.expires = expires
    }
    
    class func fromJson(jsonData: JsonObject) -> MarketOffer? {
        guard let name = jsonData["name"] as? String else {
            return nil
        }
        guard let price = jsonData["price"] as? Double else {
            return nil
        }
        
        guard let dateString = jsonData["expires"] as? String else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        return MarketOffer(name: name, price: price, expires: date)
    }
}
