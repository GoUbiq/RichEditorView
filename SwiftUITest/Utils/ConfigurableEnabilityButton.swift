//
//  ConfigurableEnabilityButton.swift
//  Apetite
//
//  Created by Bastien Ravalet on 15/04/2019.
//  Copyright © 2019 Ubiq. All rights reserved.
//

import UIKit

class ConfigurableEnabilityButton: UIButton {
	
	@IBInspectable
    private var enableBackgroundColor: UIColor! = ColorTable.mainColor {
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

class ConfigurableEnabilityButtonWithGradientBackground: UIButton {
    @IBInspectable
    var enableBackgroundTopColor: UIColor! = ColorTable.darkMainOrangeGradTopColor {
        didSet {
            self.configureBackgroundAndTitleButton()
        }
    }
    
    @IBInspectable
    var enableBackgroundBotColor: UIColor! = ColorTable.darkMainOrangeGradBotColor {
        didSet {
            self.configureBackgroundAndTitleButton()
        }
    }

    @IBInspectable
    var enableTitleColor: UIColor! = .white {
        didSet {
            self.configureBackgroundAndTitleButton()
        }
    }
    
    @IBInspectable
    var disableBackgroundTopColor: UIColor! = ColorTable.disabledGrayTopColor {
        didSet {
            self.configureBackgroundAndTitleButton()
        }
    }
    
    @IBInspectable
    var disableBackgroundBotColor: UIColor! = ColorTable.darkGrayTint {
        didSet {
            self.configureBackgroundAndTitleButton()
        }
    }
    
    @IBInspectable
    var disableTitleColor: UIColor! = ColorTable.darkGrayTint {
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
        let topColor = self.isEnabled ? self.enableBackgroundTopColor : self.disableBackgroundTopColor
        let botColor = self.isEnabled ? self.enableBackgroundBotColor : self.disableBackgroundBotColor

//        self.setGradientBackground(colorTop: topColor!, colorBottom: botColor!)
        self.backgroundColor = ColorTable.mainColor

        self.setTitleColor(self.isEnabled ? self.enableTitleColor : self.disableTitleColor, for: .normal)
        if let title = self.currentAttributedTitle {
            let string = NSMutableAttributedString(attributedString: title)
            string.addAttributes([NSMutableAttributedString.Key.foregroundColor: self.titleColor(for: .normal)!], range: NSRange(location: 0, length: string.length))
            self.setAttributedTitle(string, for: .normal)

        }
    }
}

enum ColorTable {
    static let mainGrayTextColor = UIColor(hexString: "#333333")
    static let mainGrayBackgroundColor = UIColor(hexString: "#EEEEEE")
    static let darkMainOrangeGradTopColor = UIColor(hexString: "#FF8500")
    static let darkMainOrangeGradBotColor = UIColor(hexString: "#E53B00")
    static let mainBlueGradTopColor = UIColor(hexString: "#4AD3BC")
    static let mainBlueGradBotColor = UIColor(hexString: "#0D4C7F")
    static let disabledGrayTopColor = UIColor.white
    static let disabledGrayBotColor = UIColor(hexString: "#DDDDDD")
    static let darkGrayTint = UIColor(hexString: "#74787B")
    static let yellowGradTopColor = UIColor.white
    static let yellowGradBotColor = UIColor(hexString: "#FFC000")
    static let barButtonTintColor = UIColor(hexString: "#1F1F1F")
    static let barBackgroundColor = UIColor(hexString: "#FF643E")
    static let blueBackgroundGradMidColor = UIColor(hexString: "#0D4C7F")
    static let blueBackgroundGradBotColor = UIColor(hexString: "#072640")
    static let blackBackgroundGradTopColor = UIColor(hexString: "#1F1F1F")
    static let lightBlueBackgroundGradBotColor = UIColor(hexString: "#388CB2")
    static let contestPopupHeaderGradTopColor = ColorTable.yellowGradBotColor
    static let contestPopupHeaderGradBotColor = UIColor(hexString: "#FF8500")
    static let timerGrayedOutDisabledColor = UIColor(hexString: "#BBBBBB")
    static let greenGradTopColor = UIColor(hexString: "#4DBA39")
    static let greenGradBotColor = UIColor(hexString: "#1B4B19")
    static let mainPlainRed = UIColor(hexString: "#F15C00")
    static let mainColor = UIColor(hexString: "#61AE81")
    static let secondaryColor = UIColor(hexString: "#F3948D")
    static let warningText = UIColor(hexString: "#B78600")
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
