//
//  ResetPasswordRouter.swift
//  TimeApp
//
//  Created by Tsibulko on 29.12.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol ResetPasswordRouterProtocol {
	func goBackToLoginModule()
	func showAlert(with error: Error)
	func showSuccessAlertAndDismissModule()
}

final class ResetPasswordRouter {
	weak var viewController: UIViewController?
	private let appCoordinator: AppCoordinatorProtocol

	init(appCoordinator: AppCoordinatorProtocol) {
		self.appCoordinator = appCoordinator
	}
}

// MARK: - ResetPasswordRouterProtocol
extension ResetPasswordRouter: ResetPasswordRouterProtocol {
	func goBackToLoginModule() {
		appCoordinator.dismissCurrentModule()
	}

	func showAlert(with error: Error) {
		viewController?.showAlert(with: AlertModel(message: error.localizedDescription),
								  completion: { [weak self] in
			guard let self = self else { return }
			self.viewController?.dismiss(animated: true, completion: nil)
		})
	}

	func showSuccessAlertAndDismissModule() {
		viewController?.showAlert(with: AlertModel(
			title: "Отправлено!",
			message: "Проверьте электронный адрес и следуйте инструкциям для восстановления пароля"
		),
								  completion: { [weak self] in
			guard let self = self else { return }
			self.viewController?.dismiss(animated: true, completion: {
				self.appCoordinator.dismissCurrentModule()
			})
		})
	}
}
