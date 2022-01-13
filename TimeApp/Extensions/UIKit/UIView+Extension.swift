//
//  UIView+Extension.swift
//  TimeApp
//
//  Created by Tsibulko on 19.12.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

extension UIView {
	convenience init(backgroundColor: UIColor,
					 roundedCorners: Bool = true,
					 clipsToBounds: Bool = false,
					 isShadow: Bool = false) {
		self.init()
		self.backgroundColor = backgroundColor
		self.clipsToBounds = clipsToBounds

		if roundedCorners {
			self.layer.cornerRadius = 10
		}

		if isShadow {
			self.layer.shadowColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.5)
			self.layer.shadowOpacity = 1
			self.layer.shadowOffset = .zero
			self.layer.shadowRadius = 5
		}

		self.translatesAutoresizingMaskIntoConstraints = false
	}
}
