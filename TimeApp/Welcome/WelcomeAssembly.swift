//
//  WelcomeAssembly.swift
//  TimeApp
//
//  Created by Tsibulko on 06.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol WelcomeAssemblyProtocol {
	func module() -> UIViewController
}

final class WelcomeAssembly {
	private let appCoordinator: AppCoordinatorProtocol
	private let noNameUserService: NoNameUserServiceProtocol

	init(appCoordinator: AppCoordinatorProtocol,
		 noNameUserService: NoNameUserServiceProtocol) {
		self.appCoordinator = appCoordinator
		self.noNameUserService = noNameUserService
	}
}

// MARK: - WelcomeAssemblyProtocol
extension WelcomeAssembly: WelcomeAssemblyProtocol {
	func module() -> UIViewController {
		let view = WelcomeViewController()
		let interactor = WelcomeInteractor(noNameUserService: noNameUserService)
		let router = WelcomeRouter(appCoordinator: appCoordinator)
		let presenter = WelcomePresenter(view: view, interactor: interactor, router: router)

		view.presenter = presenter
		router.viewController = view
		return view
	}
}
