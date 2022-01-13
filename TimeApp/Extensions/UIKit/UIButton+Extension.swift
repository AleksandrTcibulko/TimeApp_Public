//
//  UIButton+Extension.swift
//  TimeApp
//
//  Created by Tsibulko on 18.12.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

extension UIButton {
	convenience init(title: String,
					 target: Any?,
					 action: Selector,
					 backgroundColor: UIColor = #colorLiteral(red: 0.7882352941,
															  green: 0.9254901961,
															  blue: 0.8980392157,
															  alpha: 1),
					 isShadow: Bool = true,
					 isImage: Bool = false) {
		self.init(type: .system)
		self.setTitle(title, for: .normal)
		self.setTitleColor(.label, for: .normal)
		self.titleLabel?.font = .verdana16()
		self.backgroundColor = backgroundColor
		self.layer.cornerRadius = 10
		self.addTarget(target, action: action, for: .touchUpInside)

		if isShadow {
			self.layer.shadowOffset = CGSize(width: 0, height: 2)
			self.layer.shadowOpacity = 0.2
			self.layer.shadowRadius = 2
		}

		if isImage {
			self.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
			self.tintColor = .label
		}

		self.translatesAutoresizingMaskIntoConstraints = false
	}
}
