//
//  CostRouter.swift
//  TimeApp
//
//  Created by Tsibulko on 05.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol CostRouterProtocol {
	func goBackToMainViewController()
	func showAlert(with error: Error)
}

final class CostRouter {
	weak var viewController: UIViewController?
	private let appCoordinator: AppCoordinatorProtocol

	init(appCoordinator: AppCoordinatorProtocol) {
		self.appCoordinator = appCoordinator
	}
}

// MARK: - CostRouterProtocol
extension CostRouter: CostRouterProtocol {
	func goBackToMainViewController() {
		appCoordinator.dismissCurrentModule()
	}

	func showAlert(with error: Error) {
		viewController?.showAlert(with: AlertModel(message: error.localizedDescription),
								  completion: { [weak self] in
			guard let self = self else { return }
			self.viewController?.dismiss(animated: true, completion: nil)
		})
	}
}
