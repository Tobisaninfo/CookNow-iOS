//
//  Utils.swift
//  CookNow
//
//  Created by Tobias on 14.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func gradient(start: CGFloat = 0.5, end: CGFloat = 1) -> UIImage {
        
        UIGraphicsBeginImageContext(self.size)
        let context = UIGraphicsGetCurrentContext()
        
        self.draw(at: CGPoint(x: 0, y: 0))
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations:[CGFloat] = [0.0, 1.0]
        
        let bottom = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        let top = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        
        let colors = [top, bottom] as CFArray
        
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)
        
        let startPoint = CGPoint(x: self.size.width/2, y: self.size.height * start)
        let endPoint = CGPoint(x: self.size.width/2, y: self.size.height * end)
        
        context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
}

extension Double {
    var formatted: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        return formatter.string(from: self as NSNumber) ?? ""
    }
}

func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
    var i = 0
    return AnyIterator {
        let next = withUnsafeBytes(of: &i) { $0.load(as: T.self) }
        if next.hashValue != i { return nil }
        i += 1
        return next
    }
}
