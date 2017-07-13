//
//  Tip.swift
//  CookNow
//
//  Created by Tobias on 13.07.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

/**
 This class describs a tip. 
 */
public class Tip {
    
   // MARK: - Properties
    
    /**
     ID.
     */
    public let id: Int
    /**
     Name of the tip.
     */
    public let name: String
    /**
     Content of the tip.
     */
    public let content: String
    
    // MARK: - Initializer
    
    /**
     Create a new object from this class.
     - Parameter id: ID
     - Parameter name: Name of the tip
     - Parameter content: Content of the tip
     */
    public init(id: Int, name: String, content: String) {
        self.id = id
        self.name = name
        self .content = content
    }
    
    // MARK: - Parsing Data
    
    /**
     Parse a tip from json data. If the data is invalid, nil is returned.
     - Parameter jsonData: Json Data
     - Returns: Tip from Json Data
     */
    public class func fromJson(jsonData: HttpUtils.JsonObject) -> Tip? {
        guard let id = jsonData["id"] as? Int else {
            return nil
        }
        
        guard let name = jsonData["name"] as? String else {
            return nil
        }
        
        guard let content = jsonData["content"] as? String else {
            return nil
        }
        return Tip(id: id, name: name, content: content)
    }
}
