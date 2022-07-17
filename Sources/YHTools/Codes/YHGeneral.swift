//
//  YHGeneral.swift
//  
//
//  Created by 莹 on 2022/7/7.
//

import Foundation
import UIKit

public typealias YHHandler = () -> Void

public class YHGeneral {
    
    public static func getWidth() -> CGFloat {
        
        return UIScreen.main.bounds.size.width
    }
    
    public static func getHeight() -> CGFloat {
        
        return UIScreen.main.bounds.size.height
    }
    
    public static func getAppVersion() -> String {
        
        let info = Bundle.main.infoDictionary
        let appVersion = info?["CFBundleShortVersionString"] as! String
        return appVersion
    }
    
    public static func getAppBuildVersion() -> String {
        
        let info = Bundle.main.infoDictionary
        let appBuildVersion = info?["CFBundleVersion"] as! String
        return appBuildVersion
    }
    
    public static func isiPad() -> Bool {
        
        if UIDevice.current.model == "iPad" {
            return true
        }
        else {
            return false
        }
    }
    
    public static func isDebug() -> Bool {
        
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
}
