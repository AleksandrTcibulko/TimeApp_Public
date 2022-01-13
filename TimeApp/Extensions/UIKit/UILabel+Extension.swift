//
//  UILabel+Extension.swift
//  TimeApp
//
//  Created by Tsibulko on 19.12.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

extension UILabel {
	convenience init(text: String,
					 font: UIFont? = .verdana16(),
					 numberOfLines: Int = 1,
					 textAlignment: NSTextAlignment = .left,
					 backgroundColor: UIColor = .clear) {
		self.init()
		self.text = text
		self.font = font
		self.textColor = .label
		self.numberOfLines = numberOfLines
		self.textAlignment = textAlignment
		self.backgroundColor = backgroundColor
		self.translatesAutoresizingMaskIntoConstraints = false
	}
}
