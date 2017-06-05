//
//  MarketOffer.swift
//  CookNow
//
//  Created by Tobias on 05.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

class MarketOfferHandler {
    class func list(market: Market) -> [MarketOffer] {
        var offers: [MarketOffer] = []
        
        HttpUtils.get(url: "/market/offer/\(market.id)", callback: {
            if let jsonData = try? JSONSerialization.jsonObject(with: $0, options: []) as? JsonArray {
                if let json = jsonData {
                    for item in json {
                        if let market = MarketOffer.fromJson(jsonData: item) {
                            offers.append(market)
                        }
                    }
                }
            }
        })
        
        return offers
    }
}
