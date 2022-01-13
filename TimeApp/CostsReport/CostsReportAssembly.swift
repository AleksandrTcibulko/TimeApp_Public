//
//  CostsReportAssembly.swift
//  TimeApp
//
//  Created by Tsibulko on 13.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol CostsReportAssemblyProtocol {
	func module(with costs: [Cost], day: Date) -> UIViewController
}

final class CostsReportAssembly {
	private let appCoordinator: AppCoordinatorProtocol
	private let costService: CostServiceProtocol

	init(appCoordinator: AppCoordinatorProtocol,
		 costService: CostServiceProtocol) {
		self.appCoordinator = appCoordinator
		self.costService = costService
	}
}

// MARK: - CostsReportAssemblyProtocol
extension CostsReportAssembly: CostsReportAssemblyProtocol {
	func module(with costs: [Cost], day: Date) -> UIViewController {
		let view = CostsReportViewController()
		let interactor = CostsReportInteractor(costService: costService, costs: costs)
		let router = CostsReportRouter(appCoordinator: appCoordinator)
		let presenter = CostsReportPresenter(view: view,
											 interactor: interactor,
											 router: router,
											 day: day)

		view.presenter = presenter
		router.viewController = view
		return view
	}
}
