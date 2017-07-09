//
//  HttpUtils.swift
//  CookNow
//
//  Created by Tobias on 01.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation
import SwiftClient

public typealias JsonObject = [String:Any]
public typealias JsonArray = [[String:Any]]

class HttpUtils {
    
    class func get(url: String, callback: @escaping (Data) -> Void, error: ((Response.BasicResponseType) -> Void)? = nil) {
        let semaphore = DispatchSemaphore.init(value: 0)
        
        if let host = Bundle.main.infoDictionary?["Host"] as? String {
            let client = Client().baseUrl(url: host)
            client.get(url: url)
                .end(done: {res in
                    if (res.basicStatus == .ok) {
                        if let data = res.text?.data(using: .utf8) {
                            callback(data)
                        }
                    }
                    semaphore.signal()
                })
        }
        semaphore.wait()
    }
}
