//
//  UIActivityIndicatorView+Extension.swift
//  TimeApp
//
//  Created by Tsibulko on 18.12.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {
	convenience init(style: UIActivityIndicatorView.Style, hidesWhenStopped: Bool) {
		self.init(style: style)
		self.hidesWhenStopped = hidesWhenStopped
		self.translatesAutoresizingMaskIntoConstraints = false
	}
}
