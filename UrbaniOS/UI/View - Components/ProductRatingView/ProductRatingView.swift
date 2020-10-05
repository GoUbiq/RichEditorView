//
//  ProductRatingView.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-05.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

protocol ProductRatingDelegate {
    func rateDidChange(rating: Int?)
}

class ProductRatingView: UIView {
    private static let identifier = "ProductRatingView"
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var stars: [UIButton]!
    
    private(set) var rating: Int? = 0 {
        didSet {
            self.configureView()
        }
    }
    private var selectedColor = UIColor.white
    private var unselectedColor = UIColor.systemGray4
    private var delegate: ProductRatingDelegate? = nil
    private var isEditingEnabled: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(ProductRatingView.identifier, owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { $0.edges.equalTo(self) }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.stars.forEach { $0.imageView?.contentMode = .scaleAspectFit }
    }
    
    func configureView(rating: Int?, selectedRateColor: UIColor = .white, unselectedRateColor: UIColor = .systemGray4, editingEnabled: Bool = false, delegate: ProductRatingDelegate? = nil) {
        self.selectedColor = selectedRateColor
        self.unselectedColor = unselectedRateColor
        self.isEditingEnabled = editingEnabled
        self.rating = rating
        self.delegate = delegate
    }
    
    private func configureView() {
        self.stars.forEach {
            $0.tintColor = ($0.tag <= (self.rating ?? 0)) ? self.selectedColor : self.unselectedColor
        }
    }
    
    @IBAction private func buttonPressed(_ sender: UIButton) {
        guard self.isEditingEnabled else { return }
        self.rating = sender.tag
        self.delegate?.rateDidChange(rating: sender.tag)
    }
}
