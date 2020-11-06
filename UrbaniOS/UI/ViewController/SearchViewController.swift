//
//  SearchViewController.swift
//  UrbaniOS
//
//  Created by Bastien on 2020-11-06.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController {
    private static let identifier = "SearchViewController"
    
    class func newInstance(searchResultVC: UIViewController) -> UINavigationController {
        let navigation = UINavigationController()
        navigation.modalPresentationStyle = .pageSheet
        let instance = searchStoryboard.instantiateViewController(withIdentifier: self.identifier) as! SearchViewController
        instance.searchResultVC = searchResultVC
        navigation.setViewControllers([instance], animated: false)
        return navigation
    }
    
    private var searchResultVC: UIViewController!
    
    private lazy var searchController: UISearchController = {
        return UISearchController(searchResultsController: self.searchResultVC)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchController.searchResultsUpdater = self.searchResultVC as? UISearchResultsUpdating
        self.searchController.delegate = self
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = self.searchController
        self.searchController.searchBar.placeholder = "Search"
        self.definesPresentationContext = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchController.searchBar.text = ""
        self.searchController.isActive = true
    }
}

extension SearchViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {
            searchController.searchBar.becomeFirstResponder()
        }
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.dismiss(animated: true)
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        print("dimissed")
    }
}

