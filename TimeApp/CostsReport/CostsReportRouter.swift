//
//  CostsReportRouter.swift
//  TimeApp
//
//  Created by Tsibulko on 13.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol CostsReportRouterProtocol {
	func goBackToDayBySpheresViewController()
	func showAlert(with error: Error)
}

final class CostsReportRouter {
	weak var viewController: UIViewController?
	private let appCoordinator: AppCoordinatorProtocol

	init(appCoordinator: AppCoordinatorProtocol) {
		self.appCoordinator = appCoordinator
	}
}

// MARK: - CostsReportRouterProtocol
extension CostsReportRouter: CostsReportRouterProtocol {
	func goBackToDayBySpheresViewController() {
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
