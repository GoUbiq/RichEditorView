//
//  CircleImageView.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-09-28.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import Foundation
import UIKit

class CircleImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.layer.cornerRadius = max(self.bounds.height, self.bounds.width) / 2
    }
}
