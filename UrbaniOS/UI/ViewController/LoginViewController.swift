//
//  LoginViewController.swift
//  UrbaniOS
//
//  Created by Bastien on 2020-10-27.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import Foundation
import UIKit
import FacebookLogin
import FBSDKLoginKit

class LoginViewController: UIViewController {
    private static let identifier = "LoginViewController"

    @IBOutlet private weak var phoneLoginButton: UIButton!
    
    class func newInstance(onLoginSuccess: (DefaultBlock)? = nil) -> LoginViewController {
        let instance = loginStoryboard.instantiateViewController(withIdentifier: self.identifier) as! LoginViewController
        
        instance.onLoginSuccess = onLoginSuccess
        instance.modalPresentationStyle = .overFullScreen
        
        return instance
    }
    
    private var onLoginSuccess: (DefaultBlock)? = nil
    private var fbButton: FBLoginButton? = nil
    
    private var loginManager: STLoginManager {
        return STLoginManager.sharedInstance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupFacebookLoginButton()

        self.phoneLoginButton.layer.cornerRadius = 3
    }
    
    //MARK: - Private
    private func setupFacebookLoginButton() {
        let button = FBLoginButton(permissions: [.publicProfile, .email, .userFriends])
        self.view.addSubview(button)

        self.fbButton = button

        button.snp.makeConstraints {
            $0.centerX.equalTo(self.phoneLoginButton)
            $0.width.equalTo(self.phoneLoginButton)
            $0.height.equalTo(self.phoneLoginButton)
            $0.bottom.equalTo(self.phoneLoginButton.snp.top).offset(-20)
        }
        
        button.delegate = self
        
        self.view.layoutIfNeeded()
    }
    
    @IBAction func phoneLoginButtonPressed(_ sender: Any) {
        let vc = PhoneNumberLoginViewController.newInstance(onLoginSuccess: self.onLoginSuccess)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoginViewController: LoginButtonDelegate  {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {}
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = AccessToken.current?.tokenString else { return }

        let hud = Utils.showMessageHud(message: localized("hud.loginIn"), onViewController: self)
        self.loginManager.processLogin(withCode: token) { success in
            Utils.dismissMessageHud(hud)
            if success {
                self.dismiss(animated: true)
                self.onLoginSuccess?()
            } else {
                self.showSimpleAlertPopup(title: localized("oops"), message: localized("something.went.wrong.try.again"), buttonTitle: localized("tryAgain"))
                LoginManager().logOut()
            }
        }
    }
}
