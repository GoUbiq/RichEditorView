//
//  TextStickerEditionViewController.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-01.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit
import VerticalSlider

protocol TextStickerEditionDelegate: class {
    func editingDoneWith(stickerId: UUID, newTextInfo: TextInfo)
}

class TextStickerEditionViewController: UIViewController {
    private static let identifier = "TextStickerEditionViewController"
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var fontSlider: VerticalSlider!
    
    class func newInstance(stickerId: UUID, textInfo: TextInfo, delegate: TextStickerEditionDelegate) -> TextStickerEditionViewController {
        let instance =  cameraStoryboard.instantiateViewController(withIdentifier: self.identifier) as! TextStickerEditionViewController
        
        instance.modalPresentationStyle = .overFullScreen
        instance.modalTransitionStyle = .crossDissolve
        instance.delegate = delegate
        instance.stickerId = stickerId
        instance.textInfo = textInfo
        
        return instance
    }
    
    private var delegate: TextStickerEditionDelegate!
    private var stickerId: UUID!
    private var textInfo: TextInfo!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTextView()
        self.textView.delegate = self
        
        self.fontSlider.isHidden = self.textInfo.isTitle
        
        self.fontSlider.minimumValue = 20
        self.fontSlider.maximumValue = 70
        self.fontSlider.value = Float(self.textInfo.font.pointSize)
        self.fontSlider.addTarget(self, action: #selector(self.sliderChanged), for: .valueChanged)
        
        let inputView: TextStickerColourPickerView = .fromNib()
        inputView.frame.size = .init(width: self.view.frame.width, height: 60)
        inputView.delegate = self
        inputView.configureView()
        inputView.backgroundColor = .clear
        
        self.textView.inputAccessoryView = inputView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.textView.becomeFirstResponder()
    }
    
    private func configureTextView() {
        self.textView.text = self.textInfo.text
        self.textView.font = self.textInfo.font
        self.textView.textColor = self.textInfo.textColour
    }
    
    @IBAction private func doneButtonPressed(_ sender: Any) {
        self.delegate?.editingDoneWith(stickerId: self.stickerId, newTextInfo: self.textInfo)
        self.dismiss(animated: true)
    }
    
    @objc func sliderChanged() {
        self.textInfo.font = self.textInfo.font.withSize(CGFloat(self.fontSlider.value))
        self.configureTextView()
    }
}

extension TextStickerEditionViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.textInfo.text = textView.text
    }
}

extension TextStickerEditionViewController: TextStickerColourPickerDelegate {
    func didSelectNewColour(color: UIColor) {
        self.textInfo.textColour = color
        self.configureTextView()
    }
}
