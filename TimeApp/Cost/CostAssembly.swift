//
//  CostAssembly.swift
//  TimeApp
//
//  Created by Tsibulko on 05.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol CostAssemblyProtocol {
	func module(with costCreationInfo: CostCreationInfo) -> UIViewController
}

final class CostAssembly{
	private let appCoordinator: AppCoordinatorProtocol
	private let costService: CostServiceProtocol

	init(appCoordinator: AppCoordinatorProtocol, costService: CostServiceProtocol) {
		self.appCoordinator = appCoordinator
		self.costService = costService
	}
}

// MARK: - CostAssemblyProtocol
extension CostAssembly: CostAssemblyProtocol {
	func module(with costCreationInfo: CostCreationInfo) -> UIViewController {
		let view = CostViewController()
		let interactor = CostInteractor(costCreationInfo: costCreationInfo, costService: costService)
		let router = CostRouter(appCoordinator: appCoordinator)
		let presenter = CostPresenter(view: view, interactor: interactor, router: router)

		view.presenter = presenter
		router.viewController = view
		return view
	}
}
