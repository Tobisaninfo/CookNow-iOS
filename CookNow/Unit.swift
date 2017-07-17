//
//  Unit.swift
//  CookNow
//
//  Created by Tobias on 05.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

/**
 Enumeration of all unit types.
 */
public enum Unit: Int {
    
    // MARK: - Types
    
    /**
     Tüte / Packet
     */
    case Tuete = 1
    /**
     Stück / Piece
     */
    case Stueck
    /**
     Ml
     */
    case ML
    /**
     G
     */
    case G
    /**
     Priese / Pinch
     */
    case Priese
    /**
     EL / tbsp.
     */
    case EL
    /**
     TL / tsp.
     */
    case TL
    /**
     Ohne / Without
     */
    case Ohne
    
    // MARK: - Parsing Data
    
    /**
     Parse a Unit from json data. If the data is invalid, nil is returned.
     - Parameter jsonData: Json Data
     - Returns: Unit from Json Data
     */
    public static func fromJson(jsonData: HttpUtils.JsonObject) -> Unit? {
        guard let id = jsonData["id"] as? Int else {
            return nil
        }
        return Unit(rawValue: id)
    }
}
