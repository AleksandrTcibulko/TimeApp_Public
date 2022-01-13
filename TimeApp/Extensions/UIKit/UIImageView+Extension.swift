//
//  UIImageView+Extension.swift
//  TimeApp
//
//  Created by Tsibulko on 18.12.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

extension UIImageView {
	convenience init(image: UIImage?, contentMode: UIView.ContentMode) {
		self.init()
		self.image = image
		self.contentMode = contentMode
		self.clipsToBounds = true
		self.translatesAutoresizingMaskIntoConstraints = false
	}
}
