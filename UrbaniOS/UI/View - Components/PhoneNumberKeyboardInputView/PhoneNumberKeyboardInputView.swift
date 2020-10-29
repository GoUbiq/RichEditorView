//
//  PhoneNumberKeyboardInputView.swift
//  UrbaniOS
//
//  Created by Bastien on 2020-10-29.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

class PhoneNumberKeyboardInputView: UIView {
    
    @IBOutlet private weak var toolTipText: UILabel!
    @IBOutlet private weak var actionButton: UIButton!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init() {
        super.init(frame: CGRect.zero)
    }

    private var buttonAction: DefaultBlock? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.actionButton.layer.cornerRadius = self.actionButton.frame.height / 2
        self.actionButton.backgroundColor = .systemGreen
    }
    
    func configureView(withText text: String, buttonAction: @escaping DefaultBlock) {
        self.toolTipText.text = text
        self.buttonAction = buttonAction
    }
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        self.buttonAction?()
    }
}

