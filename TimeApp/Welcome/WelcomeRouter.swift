//
//  WelcomeRouter.swift
//  TimeApp
//
//  Created by Tsibulko on 06.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol WelcomeRouterProtocol {
	func openRegisterModule()
	func openLoginModule()
	func openMainScreen(with userId: String)
	func showAlert(with error: Error)
}

final class WelcomeRouter {
	weak var viewController: UIViewController?
	private let appCoordinator: AppCoordinatorProtocol

	init(appCoordinator: AppCoordinatorProtocol) {
		self.appCoordinator = appCoordinator
	}
}

// MARK: - WelcomeRouterProtocol
extension WelcomeRouter: WelcomeRouterProtocol {
	func openRegisterModule() {
		appCoordinator.openRegisterModule()
	}

	func openLoginModule() {
		appCoordinator.openLoginModule()
	}

	func openMainScreen(with userId: String) {
		appCoordinator.openMainScreenModule(with: userId)
	}
	
	func showAlert(with error: Error) {
		viewController?.showAlert(with: AlertModel(message: error.localizedDescription),
								  completion: { [ weak self ] in
			guard let self = self else { return }
			self.viewController?.dismiss(animated: true, completion: nil)
		})
	}
}
