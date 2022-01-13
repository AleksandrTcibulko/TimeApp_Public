//
//  CAGradientLayer+Extension.swift
//  TimeApp
//
//  Created by Tsibulko on 20.12.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

extension CAGradientLayer {
	convenience init(startColor: UIColor, endColor: UIColor) {
		self.init()
		self.startPoint = CGPoint(x: 0, y: 0)
		self.endPoint = CGPoint(x: 0, y: 1)
		self.colors = [startColor.cgColor, endColor.cgColor]
	}
}
