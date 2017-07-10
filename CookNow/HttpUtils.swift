//
//  HttpUtils.swift
//  CookNow
//
//  Created by Tobias on 01.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation
import SwiftClient

/**
 Util class for http requests.
 */
public class HttpUtils {
    
    // MARK: - Types
    
    /**
     Typealias for JSON Objects.
     */
    public typealias JsonObject = [String:Any]
    /**
     Typealias for JSON Arrays.
     */
    public typealias JsonArray = [[String:Any]]
    
    // MARK: - Methods
    
    /**
     Method to make a get request. This methods blocks the thread.
     - Parameter url: Host url
     - Parameter callback: Data callback
     */
    public class func get(url: String, callback: @escaping (Data) -> Void) {
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
