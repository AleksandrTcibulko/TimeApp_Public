//
//  RoundedTextField.swift
//  TimeApp
//
//  Created by Tsibulko on 06.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

enum TextFieldInputType {
	case hours
	case minutes
}

final class RoundedTextField: UITextField {
	let textFieldInputType: TextFieldInputType?

	let insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

	init(placeholder: String,
		 textAlignment: NSTextAlignment = .left,
		 backgroundColor: UIColor = UIColor.systemBackground.withAlphaComponent(0.9),
		 keyboardType: UIKeyboardType = .default,
		 shouldSecureText: Bool = false,
		 textFieldInputType: TextFieldInputType? = nil) {
		self.textFieldInputType = textFieldInputType
		super.init(frame: .zero)
		self.placeholder = placeholder
		self.textAlignment = textAlignment
		self.backgroundColor = backgroundColor
		self.keyboardType = keyboardType
		self.isSecureTextEntry = shouldSecureText

		self.font = .verdana16()
		self.tintColor = .lightGray
		self.layer.cornerRadius = 10
		self.autocorrectionType = .no
		self.autocapitalizationType = .none
		self.returnKeyType = .default

		self.layer.borderWidth = 0.1
		self.layer.borderColor = UIColor.lightGray.cgColor

		self.layer.shadowOffset = CGSize(width: 0, height: 2)
		self.layer.shadowOpacity = 0.2
		self.layer.shadowRadius = 2

		self.translatesAutoresizingMaskIntoConstraints = false
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: insets)
	}

	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: insets)
	}
}
