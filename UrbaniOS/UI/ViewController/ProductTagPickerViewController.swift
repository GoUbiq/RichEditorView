//
//  ProductTagPickerViewController.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-02.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

protocol ProductTagPickerDelegate: class {
    func didSelect(product: Product)
}

class ProductTagPickerViewController: UIViewController {
    static let identifier = "ProductTagPickerViewController"
    
    @IBOutlet private weak var tableView: UITableView!
    
    class func newInstance(delegate: ProductTagPickerDelegate) -> ProductTagPickerViewController {
        let instance = cameraStoryboard.instantiateViewController(withIdentifier: self.identifier) as! ProductTagPickerViewController
        instance.modalPresentationStyle = .pageSheet
        instance.delegate = delegate
        return instance
    }
    
    //MARK: - Properties
    private var productManager: ProductManager {
        return ProductManager.sharedInstance
    }
    
    private var delegate: ProductTagPickerDelegate!
    private var products: [Product] = []
    private var selectedCell: IndexPath? = nil {
        didSet {
            var reloading: [IndexPath] = []
            
            if let oldCell = oldValue {
                reloading.append(oldCell)
            }
            if let cell = self.selectedCell, oldValue != cell {
                reloading.append(cell)
            }
            
            if !reloading.isEmpty {
                self.tableView.reloadRows(at: reloading, with: .automatic)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.productManager.getProducts() { products in
            self.products = products ?? []
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.selectedCell = nil
    }
}

extension ProductTagPickerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductTagPickerTableViewCell.identifier, for: indexPath) as! ProductTagPickerTableViewCell
        cell.configureCell(product: self.products[indexPath.row], isExpended: self.selectedCell == indexPath, delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCell = indexPath
    }
}

extension ProductTagPickerViewController: ProductRatingDelegate {
    func rateDidChange(rating: Int?) {
        guard let idx = self.selectedCell?.row else { return }
        var product = self.products[idx]
        product.rating = rating
        self.delegate.didSelect(product: product)
        self.dismiss(animated: true)
    }
}

