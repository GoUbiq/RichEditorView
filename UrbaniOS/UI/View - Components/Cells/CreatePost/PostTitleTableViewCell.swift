//
//  PostTitleTableViewCell.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-09-30.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

class PostTitleTableViewCell: UITableViewCell, ConfigurableCell {
    
    @IBOutlet private(set) weak var textField: UITextField!
    @IBOutlet private weak var characterLimit: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textField.delegate = self
    }
    
    func configure(data: String) {
        self.textField.text = data
    }
}

extension PostTitleTableViewCell {
    enum Contstant {
        static let titleLimit = 50
    }
}

extension PostTitleTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let currentText = self.textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        let shouldChange = updatedText.count <= Contstant.titleLimit
        
        if shouldChange {
            self.characterLimit.text = "\(Contstant.titleLimit - updatedText.count)"
        }
        
        return shouldChange
    }
}

