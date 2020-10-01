//
//  GenericCellConfigurator.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-09-29.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

protocol ConfigurableCell {
    associatedtype DataType
    func configure(data: DataType)
}

protocol CellConfigurator {
    static var reuseId: String { get }
    var rowHeight: CGFloat { get }
    var rowTap: (DefaultBlock)? { get }
    func configure(cell: UIView)
}

class TableCellConfigurator<CellType: ConfigurableCell, DataType>: CellConfigurator where CellType.DataType == DataType, CellType: UITableViewCell {
    static var reuseId: String { return String(describing: CellType.self) }
    
    let item: DataType
    let rowHeight: CGFloat
    let rowTap: (DefaultBlock)?
    
    init(item: DataType, rowHeight: CGFloat = UITableView.automaticDimension, rowTap: (DefaultBlock)? = nil) {
        self.item = item
        self.rowHeight = rowHeight
        self.rowTap = rowTap
    }
    
    func configure(cell: UIView) {
        (cell as! CellType).configure(data: item)
    }
}
