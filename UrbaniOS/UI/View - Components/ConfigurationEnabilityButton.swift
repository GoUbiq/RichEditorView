//
//  ConfigurationEnabilityButton.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-09-28.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//


import UIKit

class ConfigurableEnabilityButton: UIButton {
    
    @IBInspectable
    private var enableBackgroundColor: UIColor! = .green {
        didSet {
            self.configureBackgroundAndTitleButton()
        }
    }
    
    @IBInspectable
    private var enableTitleColor: UIColor! = .white {
        didSet {
            self.configureBackgroundAndTitleButton()
        }
    }
    
    @IBInspectable
    private var disableBackgroundColor: UIColor! = UIColor(hexString: "#DFDFDF") {
        didSet {
            self.configureBackgroundAndTitleButton()
        }
    }
    
    @IBInspectable
    private var disableTitleColor: UIColor! = UIColor(hexString: "#A7A7A7") {
        didSet {
            self.configureBackgroundAndTitleButton()
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            self.configureBackgroundAndTitleButton()
        }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configureBackgroundAndTitleButton() {
        self.backgroundColor = self.isEnabled ? self.enableBackgroundColor : self.disableBackgroundColor
        self.setTitleColor(self.isEnabled ? self.enableTitleColor : self.disableTitleColor, for: .normal)
    }
}
