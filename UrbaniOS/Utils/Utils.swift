//
//  Utils.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-09-28.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

typealias DefaultBlock = () -> ()

class Utils {
    
    static private var currentHud: MBProgressHUD? = nil
    
    static func showSimpleAlertView(withTitle title: String? = nil, withText text: String, withButtonTitle buttonTitle: String = "Ok", buttonAction: (DefaultBlock)? = nil, onViewController vc: UIViewController) {
        let alertContoller = UIAlertController(title: title, message: text, preferredStyle: .alert)
        
        alertContoller.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: { _ in buttonAction?() }))
        
        vc.present(alertContoller, animated: true, completion: nil)
    }
    
    static func showTwoOptionAlertView(
        withTitle title: String? = nil,
        withText text: String,
        firstButtonText: String,
        firstButtonStyle: UIAlertAction.Style = .destructive,
        firstButtonAction: @escaping DefaultBlock,
        secondButtonText: String,
        secondButtonStyle: UIAlertAction.Style = .default,
        secondButtonAction: @escaping DefaultBlock,
        onViewController vc: UIViewController) {
        
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: firstButtonText, style: firstButtonStyle, handler: {_ in firstButtonAction() }))
        alertController.addAction(UIAlertAction(title: secondButtonText, style: secondButtonStyle, handler: {_ in secondButtonAction() }))
        
        vc.present(alertController, animated: true, completion: nil)
    }
    
    static func delay(delay: Double, block: @escaping DefaultBlock) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            block()
        }
    }
    
    @discardableResult
    static func showMessageHud(message: String = "", mode: MBProgressHUDMode = .indeterminate, isUserInteractionEnabled: Bool = true, onViewController vc: UIViewController) -> MBProgressHUD? {
        let view = vc.view!
        
        self.currentHud?.hide(animated: false)
        self.currentHud = MBProgressHUD.showAdded(to: view, animated: true)
        self.currentHud?.mode = mode
        self.currentHud?.isUserInteractionEnabled = isUserInteractionEnabled
        self.currentHud?.label.text = message
        self.currentHud?.label.numberOfLines = 0
        
        return self.currentHud
    }
    
    static func dismissMessageHud(_ hud: MBProgressHUD?) {
        hud?.hide(animated: true)
    }
}
