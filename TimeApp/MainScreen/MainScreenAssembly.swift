//
//  MainScreenAssembly.swift
//  TimeApp
//
//  Created by Tsibulko on 27.10.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol MainScreenAssemblyProtocol {
	func module(with userId: String) -> UIViewController
}

final class MainScreenAssembly {
	private let appCoordinator: AppCoordinatorProtocol
	private let spheresService: SpheresServiceProtocol

	init(appCoordinator: AppCoordinatorProtocol,
		 spheresService: SpheresServiceProtocol) {
		self.appCoordinator = appCoordinator
		self.spheresService = spheresService
	}
}

// MARK: - MainScreenAssemblyProtocol
extension MainScreenAssembly: MainScreenAssemblyProtocol {
	func module(with userId: String) -> UIViewController {
		let view = MainScreenViewController()
		let interactor = MainScreenInteractor(spheresService: spheresService)
		let router = MainScreenRouter(appCoordinator: appCoordinator)
		let presenter = MainScreenPresenter(view: view, interactor: interactor, router: router, userId: userId)

		view.presenter = presenter
		router.viewController = view
		return view
	}
}
