//
//  UIStackView+Extension.swift
//  TimeApp
//
//  Created by Tsibulko on 18.12.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

extension UIStackView {
	convenience init(arrangedSubviews: [UIView],
					 axis: NSLayoutConstraint.Axis,
					 distribution: UIStackView.Distribution,
					 alignment: UIStackView.Alignment,
					 spacing: CGFloat ) {
		self.init(arrangedSubviews: arrangedSubviews)
		self.axis = axis
		self.distribution = distribution
		self.alignment = alignment
		self.spacing = spacing
		self.translatesAutoresizingMaskIntoConstraints = false
	}
}
