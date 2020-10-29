//
//  PhoneOTPVerificationViewController.swift
//  UrbaniOS
//
//  Created by Bastien on 2020-10-29.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

class PhoneOTPVerificationViewController: UIViewController {
    private static let identifier = "PhoneOTPVerificationViewController"
    
    @IBOutlet private weak var codeTextField: UITextField!
    @IBOutlet private weak var codeInvalidLabel: UILabel!
    @IBOutlet var digitLabels: [UILabel]!
    
    class func newInstance(phoneNumber: String, onLoginSuccess: (DefaultBlock)? = nil) -> PhoneOTPVerificationViewController {
        let instance = loginStoryboard.instantiateViewController(withIdentifier: self.identifier) as! PhoneOTPVerificationViewController
        instance.onLoginSuccess = onLoginSuccess
        instance.phoneNumber = phoneNumber
        return instance
    }
    
    private var phoneNumber: String!
    private var onLoginSuccess: (DefaultBlock)? = nil
    
    private var loginManager: STLoginManager {
        return STLoginManager.sharedInstance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showKeyboard), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        self.codeTextField.keyboardType = .decimalPad
        self.codeTextField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        self.codeTextField.isHidden = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.codeTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.codeTextField.resignFirstResponder()
    }
    
    @objc func textFieldDidChange(sender: UITextField) {
        self.codeInvalidLabel.isHidden = true

        for (idx, label) in self.digitLabels.enumerated() {
            label.text = "\(sender.text?[safe: idx] ?? "_")"
        }
        if let text = sender.text, text.count == 4 {
            let hud = Utils.showMessageHud(onViewController: self)
            self.loginManager.processLogin(phoneNumber: self.phoneNumber, withCode: text, completionHandler: { success in
                Utils.dismissMessageHud(hud)
                if success {
                    self.navigationController?.dismiss(animated: true)
                    self.onLoginSuccess?()
                } else {
                    self.codeTextField.text = ""
                    self.textFieldDidChange(sender: self.codeTextField)
                    self.codeInvalidLabel.isHidden = false
                }
            })
        }
    }
    
    @objc func showKeyboard() {
        self.codeTextField.becomeFirstResponder()
    }
}

extension PhoneOTPVerificationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 4
    }
    
}
