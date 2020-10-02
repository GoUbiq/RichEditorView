//
//  ProductTagPickerViewController.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-02.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

class ProductTagPickerViewController: UIViewController {
    static let identifier = "ProductTagPickerViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}

extension ProductTagPickerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

