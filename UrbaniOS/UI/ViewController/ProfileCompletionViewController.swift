//
//  ProfileCompletionViewController.swift
//  UrbaniOS
//
//  Created by Bastien on 2020-10-29.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

class ProfileCompletionViewController: UIViewController {
    private static let identifier = "ProfileCompletionViewController"
    
    @IBOutlet private weak var firstNameField: UITextField!
    @IBOutlet private weak var lastNameField: UITextField!
    @IBOutlet private weak var handleField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var userImage: CircleImageView!

    class func newInstance(shouldShowCloseButton: Bool = false) -> ProfileCompletionViewController {
        let instance = loginStoryboard.instantiateViewController(withIdentifier: self.identifier) as! ProfileCompletionViewController
        instance.modalPresentationStyle = .fullScreen
        instance.shouldShowCloseButton = shouldShowCloseButton
        return instance
    }
    
    private var shouldShowCloseButton: Bool = false
    
    private var loginManager: STLoginManager {
        return STLoginManager.sharedInstance
    }
    
    private var mediaManager: MediaManager {
        return MediaManager.sharedInstance
    }
    
    private lazy var imagePicker: ImagePicker = {
       return ImagePicker(presentationController: self, delegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showKeyboard), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        self.closeButton.isHidden = !self.shouldShowCloseButton
        
        self.firstNameField.layer.cornerRadius = 3
        self.firstNameField.layer.borderWidth = 1
        self.lastNameField.layer.cornerRadius = 3
        self.lastNameField.layer.borderWidth = 1
        self.handleField.layer.cornerRadius = 3
        self.handleField.layer.borderWidth = 1
        
        self.firstNameField.text = self.loginManager.currentSession?.userFirstName
        self.lastNameField.text = self.loginManager.currentSession?.userLastName
        self.userImage.sd_setImage(with: self.loginManager.currentSession?.userImgUrl, placeholderImage: #imageLiteral(resourceName: "user-silhouette"))
        
        self.configureTextFields()
        
        self.firstNameField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        self.lastNameField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        self.handleField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        
        let keyboardInputView: PhoneNumberKeyboardInputView = .fromNib()
        
        keyboardInputView.backgroundColor = .clear
        keyboardInputView.configureView(
            withText: localized("login.keyboardInput.completeProfile"),
            buttonAction: {
                guard self.configureTextFields(),
                    let firstName = self.firstNameField.text,
                    let lastName = self.lastNameField.text,
                    let handle = self.handleField.text else { return }
                
                let hud = Utils.showMessageHud(onViewController: self)
                self.loginManager.updateUserInfos(newFirstName: firstName, newHandle: handle, newLastName: lastName, completionHandler: { session in
                    Utils.dismissMessageHud(hud)
                    if session == nil {
                        self.showSimpleAlertPopup(message: localized("something.went.wrong.try.again"))
                    } else {
//                        NotificationCenter.default.post(name: .shouldReloadProfile, object: nil)
                        self.dismiss(animated: true)
                    }
                })
            }
        )
        
        self.firstNameField.inputAccessoryView = keyboardInputView
        self.lastNameField.inputAccessoryView = keyboardInputView
        self.handleField.inputAccessoryView = keyboardInputView
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.showKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.firstNameField.resignFirstResponder()
        self.lastNameField.resignFirstResponder()
        self.handleField.resignFirstResponder()
    }
    
    @objc private func textFieldDidChange(sender: UITextField) {
        self.configureTextFields()
    }
    
    @objc private func showKeyboard() {
        if (self.firstNameField.text ?? "").isEmpty {
            self.firstNameField.becomeFirstResponder()
        } else if (self.lastNameField.text ?? "").isEmpty {
            self.lastNameField.becomeFirstResponder()
        } else {
            self.handleField.becomeFirstResponder()
        }
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @discardableResult
    private func configureTextFields() -> Bool {
        let firstName = self.firstNameField.text ?? ""
        let lastName = self.lastNameField.text ?? ""
        let handle = self.handleField.text ?? ""

        self.firstNameField.layer.borderColor = (firstName.isEmpty ? UIColor.red : UIColor.clear).cgColor
        self.lastNameField.layer.borderColor = (lastName.isEmpty ? UIColor.red : UIColor.clear).cgColor
        self.handleField.layer.borderColor = (handle.isEmpty ? UIColor.red : UIColor.clear).cgColor
        self.errorLabel.isHidden = !((firstName.isEmpty) || (lastName.isEmpty) || (handle.isEmpty))
        return !(firstName.isEmpty || lastName.isEmpty || handle.isEmpty)
    }

    @IBAction func editProfilePictureButtonPressed(_ sender: Any) {
        self.imagePicker.present(from: self.view)
    }
}

extension ProfileCompletionViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let image = image else { return }
        let hud = Utils.showMessageHud(message: "Uploading new profile picture...", onViewController: self)
        self.mediaManager.uploadImage(image: image, completionHandler: { success in
            Utils.dismissMessageHud(hud)
            if success {
                self.userImage.sd_setImage(with: self.loginManager.currentSession?.userImgUrl, placeholderImage: #imageLiteral(resourceName: "user-silhouette"))
            } else {
                self.showSimpleAlertPopup(message: "Something wen't wrong on the upload of your new picture, please try again.")
            }
        })
    }
}

