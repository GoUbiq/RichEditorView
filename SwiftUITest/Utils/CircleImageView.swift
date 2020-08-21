//
//  CircleImageView.swift
//  Apetite
//
//  Created by Bastien Ravalet on 27/02/2019.
//  Copyright © 2019 Ubiq. All rights reserved.
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
