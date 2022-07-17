//
//  YHAlert.swift
//  
//
//  Created by 莹 on 2022/7/7.
//

import Foundation
import MBProgressHUD

public class YHAlert {
    
    private static var waitHud:MBProgressHUD?
    
    public static func showMessage(text:String,view:UIView,delay:TimeInterval = 1.5,completion:YHHandler? = nil) {
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text
        hud.label.text = text
        hud.label.numberOfLines = 0
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: delay)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+delay, execute: {completion?()})
    }
    
    public static func showWait(text:String?, view:UIView) {
        
        waitHud = MBProgressHUD.showAdded(to: view, animated: true)
        waitHud?.label.text = text
        waitHud?.label.numberOfLines = 0
        waitHud?.removeFromSuperViewOnHide = true
    }
    
    public static func stopWait() {
        
        waitHud?.hide(animated: true)
        waitHud = nil
    }
    
    public static func showSuccess(text:String?,view:UIView,delay:TimeInterval = 1.5,completion:YHHandler? = nil) {
    
        showCustomHud(imageNamed: "checkmark", text: text, view: view, delay: delay, completion: completion)
    }
    
    public static func showFail(text:String?,view:UIView,delay:TimeInterval = 1.5,completion:YHHandler? = nil) {
        
        showCustomHud(imageNamed: "xmark", text: text, view: view, delay: delay, completion: completion)
    }
    
    private static func showCustomHud(imageNamed:String,text:String?,view:UIView,delay:TimeInterval,completion:YHHandler? = nil) {
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .customView
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        imageView.image = UIImage(systemName: imageNamed, withConfiguration: UIImage.SymbolConfiguration(pointSize: 60, weight: .regular))
        imageView.tintColor = UIColor.label
        hud.customView = imageView
        
        hud.label.text = text
        hud.label.numberOfLines = 0
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: delay)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+delay, execute: {completion?()})
    }
}
