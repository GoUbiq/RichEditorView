//
//  PostBodyTableViewCell.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-09.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit
import WebKit

protocol PostBodyCellDelegate: class {
    func didPressAddProductTag(cell: PostBodyTableViewCell)
}

class PostBodyTableViewCell: UITableViewCell, ConfigurableCell {
    static let identifier = "PostBodyTableViewCell"
    
    @IBOutlet private(set) weak var richText: RichEditorView!
    @IBOutlet private weak var placeHolder: UILabel!
    
    private var info: CellInfo!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap: UITapGestureRecognizer = .init(target: self, action: #selector(self.viewTap(_:)))
        tap.delegate = self
        self.richText.webView.addGestureRecognizer(tap)
        self.configureRichTxt()
    }
    
    func configureRichTxt() {
        self.richText.delegate = self
        self.richText.editingEnabled = true
        self.richText.placeholder = "Critq content"

        let toolBar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolBar.editor = self.richText
//        toolBar.delegate = self
        
        let item = RichEditorOptionItem(image: nil, title: "Product") { toolbar in
            self.info.delegate.didPressAddProductTag(cell: self)
        }
        
        let hideKB = RichEditorOptionItem(image: nil, title: "Hide") { toolbar in
            toolbar.editor?.endEditing(true)
        }
        
        toolBar.options = [item, hideKB, RichEditorDefaultOption.unorderedList, RichEditorDefaultOption.bold, RichEditorDefaultOption.italic]

        self.richText.inputAccessoryView = toolBar
    }
    
    func addProductTag(tag: ProductTag) {
        self.richText.runJS("RE.insertProductTag(\"\(tag.product.title)\", \"\(tag.product.url)\", \"\(tag.rating ?? 0)\");")
    }

    func configure(data: CellInfo) {
        self.info = data
    }
    
    @objc func viewTap(_ sender: UITapGestureRecognizer) {
        _ = self.richText.becomeFirstResponder()
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension PostBodyTableViewCell {
    struct CellInfo {
        var delegate: PostBodyCellDelegate
    }
}

extension PostBodyTableViewCell: RichEditorDelegate {
    func richEditor(_ editor: RichEditorView, shouldInteractWith url: URL) -> Bool {
        print(url.absoluteString)
        return true
    }
    
    func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
        print(content)
        self.placeHolder.isHidden = !(content.isEmpty || content == "<br>")
    }
    
    func richEditorTookFocus(_ editor: RichEditorView) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            editor.focus()
            editor.becomeFirstResponder()
            editor.webView.becomeFirstResponder()
        }
    }
}
