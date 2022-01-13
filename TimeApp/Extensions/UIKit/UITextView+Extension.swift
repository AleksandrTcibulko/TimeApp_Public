//
//  UITextView+Extension.swift
//  TimeApp
//
//  Created by Tsibulko on 21.12.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

extension UITextView {
	convenience init(placeholder: String) {
		self.init()
		self.text = placeholder
		self.font = .verdana16()
		self.tintColor = .lightGray
		self.autocapitalizationType = .sentences
		self.autocorrectionType = .default
		self.returnKeyType = .default

		self.textContainerInset = UIEdgeInsets(top: 15, left: 5, bottom: 15, right: 5)
		self.textContainer.maximumNumberOfLines = 4
		self.textContainer.lineBreakMode = .byTruncatingTail

		self.backgroundColor = .systemBackground

		self.layer.borderWidth = 0.1
		self.layer.borderColor = UIColor.lightGray.cgColor

		self.layer.cornerRadius = 10

		self.clipsToBounds = false

		self.layer.shadowOffset = CGSize(width: 0, height: 2)
		self.layer.shadowOpacity = 0.2
		self.layer.shadowRadius = 2

		self.translatesAutoresizingMaskIntoConstraints = false
	}
}
