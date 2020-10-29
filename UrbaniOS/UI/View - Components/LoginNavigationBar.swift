//
//  LoginNavigationBar.swift
//  UrbaniOS
//
//  Created by Bastien on 2020-10-29.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

class LoginNavigationBar: UINavigationBar {
    lazy var closeButton: UIButton = {
        let button = UIButton(frame: .zero)
        
        button.setTitle("", for: .normal)
        button.setImage(#imageLiteral(resourceName: "nav-close"), for: .normal)
        
        self.addSubview(button)
        
        button.snp.makeConstraints {
            $0.centerY.equalTo(self)
            $0.trailing.equalTo(-15)
            $0.height.equalTo(35)
            $0.width.equalTo(35)
        }
        
        return button
    }()
}

class LoginNavigationController: UINavigationController {
    static let identifier = "LoginNavigationController"
    
    private var onLoginSuccess: (DefaultBlock)? = nil
    
    class func newInstance(onLoginSuccess: (DefaultBlock)? = nil) -> LoginNavigationController {
        let instance = loginStoryboard.instantiateViewController(withIdentifier: self.identifier) as! LoginNavigationController
        instance.onLoginSuccess = onLoginSuccess
        instance.modalPresentationStyle = .fullScreen
        return instance
    }
    
    open override var navigationBar: LoginNavigationBar {
        guard let navBar = super.navigationBar as? LoginNavigationBar else {
            fatalError("Please set the custom navigation bar class in the storyboard with BWNavigationBar before using")
        }
        
        return navBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.tintColor = .label
        self.navigationBar.backgroundColor = UIColor.clear
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.closeButton.addTarget(self, action: #selector(self.crossButtonPressed), for: .touchUpInside)
        
        if let onLoginSuccess = self.onLoginSuccess {
            let vc = LoginViewController.newInstance(onLoginSuccess: onLoginSuccess)
            self.setViewControllers([vc], animated: false)
        }
    }
    
    @objc func crossButtonPressed() {
        self.dismiss(animated: true)
    }
}

