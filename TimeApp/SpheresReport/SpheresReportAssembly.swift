//
//  SpheresReportAssembly.swift
//  TimeApp
//
//  Created by Tsibulko on 13.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol SpheresReportAssemblyProtocol {
	func module(with userId: String, date: Date) -> UIViewController
}

final class SpheresReportAssembly {
	private let appCoordinator: AppCoordinatorProtocol
	private let costService: CostServiceProtocol

	init(appCoordinator: AppCoordinatorProtocol, costService: CostServiceProtocol) {
		self.appCoordinator = appCoordinator
		self.costService = costService
	}
}

// MARK: - SpheresReportAssemblyProtocol
extension SpheresReportAssembly: SpheresReportAssemblyProtocol {
	func module(with userId: String, date: Date) -> UIViewController {
		let view = SpheresReportViewController()
		let interactor = SpheresReportInteractor(costService: costService)
		let router = SpheresReportRouter(appCoordinator: appCoordinator)
		let presenter = SpheresReportPresenter(view: view,
											   interactor: interactor,
											   router: router,
											   userId: userId,
											   currentDate: date)

		view.presenter = presenter
		router.viewController = view
		return view
	}
}
