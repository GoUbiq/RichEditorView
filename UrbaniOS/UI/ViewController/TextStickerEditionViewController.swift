//
//  TextStickerEditionViewController.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-01.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

protocol TextStickerEditionDelegate: class {
    func editingDoneWith(stickerId: UUID, newText: String)
}

class TextStickerEditionViewController: UIViewController {
    private static let identifier = "TextStickerEditionViewController"
    
    @IBOutlet weak var textView: UITextView!
    
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
        
        self.textView.text = self.textInfo.text
        self.textView.font = self.textView.font
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.textView.becomeFirstResponder()
    }
    
    @IBAction private func doneButtonPressed(_ sender: Any) {
        self.delegate?.editingDoneWith(stickerId: self.stickerId, newText: self.textView.text)
        self.dismiss(animated: true)
    }
}
