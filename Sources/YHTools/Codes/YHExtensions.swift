//
//  Extensions.swift
//  
//
//  Created by 莹 on 2022/7/7.
//

import Foundation
import UIKit

public extension NSObject {
    
    class var yh_className:String {
        
        get {
            return String(describing: self)
        }
    }
}

public extension UIColor {
    
    convenience init?(hex: String) {
        let r, g, b: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber),hexColor.count == 6 {
                
                r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                b = CGFloat(hexNumber & 0x0000ff) / 255

                self.init(red: r, green: g, blue: b, alpha: 1)
                return
            }
        }

        return nil
    }
}
