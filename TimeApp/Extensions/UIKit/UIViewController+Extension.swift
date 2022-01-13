//
//  UIViewController+Extension.swift
//  TimeApp
//
//  Created by Tsibulko on 20.12.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

struct AlertModel {
	let title: String
	let message: String
	let actionTitle: String

	init(title: String = "Упс!", message: String, actionTitle: String = "Ок") {
		self.title = title
		self.message = message
		self.actionTitle = actionTitle
	}
}

extension UIViewController {
	func showAlert(with alertModel: AlertModel, completion: @escaping () -> Void = {}) {
		let alertController = UIAlertController(title: alertModel.title,
												message: alertModel.message,
												preferredStyle: .alert)
		alertController.view.tintColor = .label
		alertController.addAction(UIAlertAction(title: alertModel.actionTitle,
												style: .default,
												handler: { _ in
			completion()
		}))
		TapTic.makeErrorVibro()
		present(alertController, animated: true)
	}
}

extension UIViewController {
	func setGradientBackground() {
		let gradient = CAGradientLayer(startColor: #colorLiteral(red: 0.9960784314, green: 0.7882352941, blue: 0.768627451, alpha: 1), endColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
		gradient.frame = CGRect(x: 0, y: 0,
								width: view.bounds.size.width,
								height: view.bounds.size.height)
		view.layer.insertSublayer(gradient, at: 0)
	}
}
