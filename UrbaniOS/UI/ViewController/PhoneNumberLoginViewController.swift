//
//  PhoneNumberLoginViewController.swift
//  UrbaniOS
//
//  Created by Bastien on 2020-10-29.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit
import PhoneNumberKit

class PhoneNumberLoginViewController: UIViewController {
    static let identifier = "PhoneNumberLoginViewController"
    
    @IBOutlet private weak var phoneNumberTextField: PhoneNumberTextField!
    @IBOutlet private weak var invalidNumberMessage: UILabel!
    
    class func newInstance(onLoginSuccess: (DefaultBlock)? = nil) -> PhoneNumberLoginViewController {
        let instance = loginStoryboard.instantiateViewController(withIdentifier: self.identifier) as! PhoneNumberLoginViewController
        instance.onLoginSuccess = onLoginSuccess
        return instance
    }
    
    private var onLoginSuccess: (DefaultBlock)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showKeyboard), name: UIApplication.didBecomeActiveNotification, object: nil)

        self.phoneNumberTextField.layer.borderWidth = 1
        self.phoneNumberTextField.layer.cornerRadius = 2
        self.phoneNumberTextField.defaultRegion = "US"
        self.configureTextFieldSuccessState(isSuccess: true)
        
        self.phoneNumberTextField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        
        let keyboardInputView: PhoneNumberKeyboardInputView = .fromNib()
        
        keyboardInputView.backgroundColor = .clear
        keyboardInputView.configureView(
            withText: localized("login.phone.receiveSms"),
            buttonAction: {
                if let text = self.phoneNumberTextField.text, self.phoneNumberTextField.isValidNumber {
                    let hud = Utils.showMessageHud(onViewController: self)
                    STLoginManager.sharedInstance.authenticatePhoneNumber(phoneNumber: text) { success in
                        Utils.dismissMessageHud(hud)
                        if success {
                            let vc = PhoneOTPVerificationViewController.newInstance(phoneNumber: text, onLoginSuccess: self.onLoginSuccess)
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            self.showSimpleAlertPopup(message: localized("something.went.wrong.try.again"))
                        }
                    }
                } else {
                    self.configureTextFieldSuccessState(isSuccess: false)
                }
            }
        )

        self.phoneNumberTextField.inputAccessoryView = keyboardInputView
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.phoneNumberTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.phoneNumberTextField.resignFirstResponder()
    }
    
    @objc func textFieldDidChange(sender: UITextField) {
        self.configureTextFieldSuccessState(isSuccess: true)
    }
    
    @objc func showKeyboard() {
        self.phoneNumberTextField.becomeFirstResponder()
    }
    
    private func configureTextFieldSuccessState(isSuccess: Bool) {
        self.phoneNumberTextField.layer.borderColor = (isSuccess ? UIColor.clear : UIColor.red).cgColor
        self.invalidNumberMessage.isHidden = isSuccess
    }
}

