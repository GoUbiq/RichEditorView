//
//  CreateProductViewController.swift
//  UrbaniOS
//
//  Created by Bastien on 2020-11-05.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

protocol CreateProductDelegate: class {
    func didCreateNewProduct(product: Product, withRating: Int?)
}

class CreateProductViewController: UIViewController {
    private static let identifier = "CreateProductViewController"
    
    @IBOutlet private weak var productNameField: UITextField!
    @IBOutlet private weak var productNameCharLimitLabel: UILabel!
    @IBOutlet private weak var productUrlField: UITextField!
    @IBOutlet private weak var ratingView: ProductRatingView!

    class func newInstance(delegate: CreateProductDelegate) -> UINavigationController {
        let navigation = UINavigationController()
        let instance = cameraStoryboard.instantiateViewController(withIdentifier: self.identifier) as! CreateProductViewController
        instance.delegate = delegate

        navigation.setViewControllers([instance], animated: false)

        navigation.navigationBar.tintColor = .label
        navigation.modalPresentationStyle = .overFullScreen
        
        return navigation
    }
    
    private var delegate: CreateProductDelegate? = nil
    private var productManager: ProductManager {
        return .sharedInstance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.nextButtonPressed))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "nav-close"), style: .plain, target: self, action: #selector(self.dismissView))
        
        self.ratingView.configureView(rating: nil, editingEnabled: true, delegate: self)
    }
    
    @IBAction func notNowButtonPressed(_ sender: Any) {
        self.ratingView.configureView(rating: nil, editingEnabled: true, delegate: self)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
    
    @objc func nextButtonPressed() {
        guard let title = self.productNameField.text, !title.isEmpty else {
            self.showSimpleAlertPopup(message: "A product title is required!")
            return
        }
        
        let hud = Utils.showMessageHud(onViewController: self)
        self.productManager.createProduct(title: title, url: URL(string: self.productUrlField.text ?? "")?.absoluteString ?? "") { product in
            Utils.dismissMessageHud(hud)
            guard let product = product else { return }
            self.dismissView()
            self.delegate?.didCreateNewProduct(product: product, withRating: self.ratingView.rating)
        }
    }
}

extension CreateProductViewController: ProductRatingDelegate {
    func rateDidChange(rating: Int?) {
        self.ratingView.configureView(rating: rating, editingEnabled: true, delegate: self)
    }
}

