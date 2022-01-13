//
//  SpheresReportRouter.swift
//  TimeApp
//
//  Created by Tsibulko on 13.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol SpheresReportRouterProtocol {
	func openCostsReport(with costs: [Cost], at date: Date)
	func goBackToMainScreen()
	func showAlert(with error: Error)
}

final class SpheresReportRouter {
	weak var viewController: UIViewController?
	private let appCoordinator: AppCoordinatorProtocol

	init(appCoordinator: AppCoordinatorProtocol) {
		self.appCoordinator = appCoordinator
	}
}

// MARK: - SpheresReportRouterProtocol
extension SpheresReportRouter: SpheresReportRouterProtocol {
	func goBackToMainScreen() {
		appCoordinator.dismissCurrentModule()
	}

	func openCostsReport(with costs: [Cost], at date: Date) {
		appCoordinator.openCostsReportModule(with: costs, at: date)
	}

	func showAlert(with error: Error) {
		viewController?.showAlert(with: AlertModel(message: error.localizedDescription),
								  completion: { [weak self] in
			guard let self = self else { return }
			self.viewController?.dismiss(animated: true, completion: nil)
		})
	}
}
