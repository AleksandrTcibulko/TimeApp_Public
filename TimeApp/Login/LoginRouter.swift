//
//  LoginRouter.swift
//  TimeApp
//
//  Created by Tsibulko on 06.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol LoginRouterProtocol {
	func goBackToWelcomeModule()
	func showAlert(with error: Error)
	func openMainScreen(with userId: String)
	func openResetPasswordModule()
}

final class LoginRouter {
	weak var viewController: UIViewController?
	private let appCoordinator: AppCoordinatorProtocol

	init(appCoordinator: AppCoordinatorProtocol) {
		self.appCoordinator = appCoordinator
	}
}

// MARK: - LoginRouterProtocol
extension LoginRouter: LoginRouterProtocol {
	func goBackToWelcomeModule() {
		appCoordinator.dismissCurrentModule()
	}

	func showAlert(with error: Error) {
		viewController?.showAlert(with: AlertModel(message: error.localizedDescription),
								  completion: { [weak self] in
			guard let self = self else { return }
			self.viewController?.dismiss(animated: true, completion: nil)
		})
	}

	func openMainScreen(with userId: String) {
		viewController?.showAlert(with: AlertModel(title: "Отлично!",
												   message: "Вход в систему успешно выполнен!",
												   actionTitle: "Продолжить"), completion: { [weak self] in
			guard let self = self else { return }
			self.viewController?.dismiss(animated: true, completion: {
				self.appCoordinator.openMainScreenModule(with: userId)
			})
		})
	}

	func openResetPasswordModule() {
		appCoordinator.openResetPasswordModule()
	}
}
