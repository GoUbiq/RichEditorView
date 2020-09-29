//
//  Utils.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-09-28.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import Foundation
import UIKit

typealias DefaultBlock = () -> ()

class Utils {
    
    static func showSimpleAlertView(withTitle title: String? = nil, withText text: String, withButtonTitle buttonTitle: String = "Ok", buttonAction: (DefaultBlock)? = nil, onViewController vc: UIViewController) {
        let alertContoller = UIAlertController(title: title, message: text, preferredStyle: .alert)
        
        alertContoller.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: { _ in buttonAction?() }))
        
        vc.present(alertContoller, animated: true, completion: nil)
    }
    
    static func delay(delay: Double, block: @escaping DefaultBlock) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            block()
        }
    }
}
