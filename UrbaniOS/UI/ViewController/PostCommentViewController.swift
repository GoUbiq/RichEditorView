//
//  PostCommentViewController.swift
//  UrbaniOS
//
//  Created by Bastien on 2020-10-28.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit
import UITextView_Placeholder

protocol PostCommentDelegate {
    func didPostComment(comment: Comment)
}

class PostCommentViewController: UIViewController {
    static let identifier = "PostCommentViewController"
    
    @IBOutlet private weak var textView: UITextView!
    
    class func newInstance(critiqueId: String, delegate: PostCommentDelegate) -> PostCommentViewController {
        let instance = postStoryboard.instantiateViewController(withIdentifier: self.identifier) as! PostCommentViewController
        instance.modalPresentationStyle = .overCurrentContext
        instance.delegate = delegate
        instance.critiqueId = critiqueId
        return instance
    }
    
    private var delegate: PostCommentDelegate? = nil
    private var critiqueId: String!
    private var critiqueManager: CritiqueManager {
        return .sharedInstance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.placeholder = "Write a comment"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.textView.becomeFirstResponder()
    }
    
    @IBAction private func postButtonPressed(_ sender: Any) {
        let hud = Utils.showMessageHud(onViewController: self)
        self.critiqueManager.postComment(critiqueId: self.critiqueId, text: self.textView.text) { comment in
            guard let comment = comment else {
                Utils.dismissMessageHud(hud)
                self.showSimpleAlertPopup(message: "Something wen't wrong, please try again!")
                return
            }
            self.delegate?.didPostComment(comment: comment)
            Utils.dismissMessageHud(hud)
            self.textView.resignFirstResponder()
            self.dismiss(animated: false)
        }
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        self.textView.resignFirstResponder()
        self.dismiss(animated: false)
    }
}
