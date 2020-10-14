//
//  PostBodyTableViewCell.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-09.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit
import ZSSRichTextEditor
import WebKit
import RichEditorView

protocol PostBodyCellDelegate: class {
    func didPressAddProductTag(cell: PostBodyTableViewCell)
}

class PostBodyTableViewCell: UITableViewCell, ConfigurableCell {
    static let identifier = "PostBodyTableViewCell"
    
    @IBOutlet private weak var richText: RichEditorView!
    @IBOutlet private weak var webView: WKWebView!
    
    private var info: CellInfo!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.richText.delegate = self
        self.richText.isEditingEnabled = true
//
        let toolBar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolBar.options = RichEditorDefaultOption.all
        toolBar.editor = self.richText
        toolBar.delegate = self
        
        let item = RichEditorOptionItem(image: nil, title: "Tag") { toolbar in
            self.info.delegate.didPressAddProductTag(cell: self)
        }
        
        let hideKB = RichEditorOptionItem(image: nil, title: "Hide") { toolbar in
            toolbar.editor?.endEditing(true)
        }
        
        toolBar.options = [item, hideKB]

        self.richText.inputAccessoryView = toolBar
    }
    
    func addProductTag(product: Product) {
        self.richText.runJS("RE.insertProductTag(\"\(product.title)\", \"www.google.com\", \"\(product.rating ?? 1)\");")
    }
    
//    private func convertSpecialCharacters(string: String) -> String {
//            var newString = string
//            let char_dictionary = [
//                "&amp;" : "&",
//                "&lt;" : "<",
//                "&gt;" : ">",
//                "&quot;" : "\"",
//                "&apos;" : "'"
//            ];
//            for (escaped_char, unescaped_char) in char_dictionary {
//                newString = newString.replacingOccurrences(of: escaped_char, with: unescaped_char, options: NSString.CompareOptions.literal, range: nil)
//            }
//            return newString
//    }

    func configure(data: CellInfo) {
        self.info = data
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
}

extension PostBodyTableViewCell: RichEditorToolbarDelegate {

    fileprivate func randomColor() -> UIColor {
        let colors: [UIColor] = [
            .red,
            .orange,
            .yellow,
            .green,
            .blue,
            .purple
        ]
        
        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        return color
    }

    func richEditorToolbarChangeTextColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextColor(color)
    }

    func richEditorToolbarChangeBackgroundColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextBackgroundColor(color)
    }

    func richEditorToolbarInsertImage(_ toolbar: RichEditorToolbar) {
        toolbar.editor?.insertImage("https://gravatar.com/avatar/696cf5da599733261059de06c4d1fe22", alt: "Gravatar")
    }

    func richEditorToolbarInsertLink(_ toolbar: RichEditorToolbar) {
        // Can only add links to selected text, so make sure there is a range selection first
        if toolbar.editor?.hasRangeSelection == true {
            toolbar.editor?.insertLink("http://github.com/cjwirth/RichEditorView", title: "Github Link")
        }
    }
}

