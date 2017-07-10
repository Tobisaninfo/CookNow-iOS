//
//  MarketOffer.swift
//  CookNow
//
//  Created by Tobias on 05.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

/**
 A MarketOffer is a class that contains information about market offers.
 */
public class MarketOffer {
    
    // MARK: - Cache
    
    /**
     Notification when offer cache is updated.
     */
    public static let MarketOfferUpdate = Notification.Name("MarketOfferUpdate")

    /**
     Local, global cache for market offers. Use ```MarketOfferHandler``` to get offers.
     */
    public static var offers: [MarketOffer] = [] {
        didSet {
            NotificationCenter.default.post(name: MarketOfferUpdate, object: self)
        }
    }
    
    // MARK: - Properties
    
    /**
     Name of the offer.
     */
    public let name: String
    /**
     Price of the offer.
     */
    public let price: Double
    /**
     Expire date of the offer.
     */
    public let expires: Date
    
    // MARK: - Initializer
    
    /**
     Create a new offer.
     - Parameter name: Offer name
     - Parameter price: Price
     - Parameter expires: Date of expire
     */
    public init(name: String, price: Double, expires: Date) {
        self.name = name
        self.price = price
        self.expires = expires
    }
    
    // MARK: - Parsing Data
    
    /**
     Parse a MarketOffer from json data. If the data is invalid, nil is returned.
     - Parameter jsonData: Json Data
     - Returns: MarketOffer from Json Data
     */
    public class func fromJson(jsonData: HttpUtils.JsonObject) -> MarketOffer? {
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
