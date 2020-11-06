//
//  ProductTagPickerSearchResultViewController.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-02.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

protocol ProductTagPickerDelegate: class {
    func didSelect(tag: ProductTag)
}

class ProductTagPickerSearchResultViewController: UIViewController {
    static let identifier = "ProductTagPickerSearchResultViewController"
    
    @IBOutlet private weak var tableView: UITableView!
    
    class func newInstance(delegate: ProductTagPickerDelegate) -> ProductTagPickerSearchResultViewController {
        let instance = cameraStoryboard.instantiateViewController(withIdentifier: self.identifier) as! ProductTagPickerSearchResultViewController
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

extension ProductTagPickerSearchResultViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension ProductTagPickerSearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : self.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Create a new product"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductTagPickerTableViewCell.identifier, for: indexPath) as! ProductTagPickerTableViewCell
            cell.configureCell(product: self.products[indexPath.row], isExpended: self.selectedCell == indexPath, delegate: self)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vc = CreateProductViewController.newInstance(delegate: self)
            self.present(vc, animated: true)
        } else {
            self.selectedCell = indexPath
        }
    }
}

extension ProductTagPickerSearchResultViewController: ProductRatingDelegate {
    func rateDidChange(rating: Int?) {
        guard let idx = self.selectedCell?.row else { return }
        self.delegate.didSelect(tag: .init(rating: rating, positionX: 0.5, positionY: 0.5, product: self.products[idx]))
        self.dismiss(animated: true)
    }
}

extension ProductTagPickerSearchResultViewController: CreateProductDelegate {
    func didCreateNewProduct(product: Product, withRating: Int?) {
        let tag: ProductTag = .init(rating: withRating, positionX: 0.5, positionY: 0.5, product: product)
        self.delegate.didSelect(tag: tag)
        self.dismiss(animated: true)
    }
}

