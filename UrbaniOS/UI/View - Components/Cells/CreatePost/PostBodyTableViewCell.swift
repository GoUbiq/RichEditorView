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

class PostBodyTableViewCell: UITableViewCell, ConfigurableCell {
    static let identifier = "PostBodyTableViewCell"
    
    
    @IBOutlet private weak var richText: RichEditorView!
    @IBOutlet private weak var webView: WKWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.richText. = "Enter body stp"

        self.richText.delegate = self
        self.richText.isEditingEnabled = true
//
        let toolBar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolBar.options = RichEditorDefaultOption.all
        toolBar.editor = self.richText
        toolBar.delegate = self
        
        let item = RichEditorOptionItem(image: nil, title: "Tag") { toolbar in
            toolbar.editor?.insertLink("http://github.com/cjwirth/RichEditorView", title: "Github Link")
        }
        
//        toolBar.options = [item]

        self.richText.inputAccessoryView = toolBar
    }
    
    func configure(data: String) {
        
        if let filepath = Bundle.main.path(forResource: "index", ofType: "html") {
            do {
                let contents = try String(contentsOfFile: filepath)
                print(contents)
                self.richText.html = contents
            } catch {
                // contents could not be loaded
            }
        } else {
            // example.txt not found!
        }
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

