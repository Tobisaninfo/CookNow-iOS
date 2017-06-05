//
//  Unit.swift
//  CookNow
//
//  Created by Tobias on 05.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

enum Unit: Int {
    case Tuete = 1
    case Strueck
    case ML
    case G
    case Prise
    case EL
    case TL
    case Ohne
    
    static func fromJson(jsonData: [String:Any]) -> Unit? {
        guard let id = jsonData["id"] as? Int else {
            return nil
        }
        return Unit(rawValue: id)
    }
}
