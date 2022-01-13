//
//  RegisterAssembly.swift
//  TimeApp
//
//  Created by Tsibulko on 06.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol RegisterAssemblyProtocol {
	func module() -> UIViewController
}

final class RegisterAssembly {
	private let appCoordinator: AppCoordinatorProtocol
	private let registeredUserService: RegisteredUserServiceProtocol
	private let noNameUserService: NoNameUserServiceProtocol
	private let costService: CostServiceProtocol

	init(appCoordinator: AppCoordinatorProtocol,
		 registeredUserService: RegisteredUserServiceProtocol,
		 noNameUserService: NoNameUserServiceProtocol,
		 costService: CostServiceProtocol) {
		self.appCoordinator = appCoordinator
		self.registeredUserService = registeredUserService
		self.noNameUserService = noNameUserService
		self.costService = costService
	}
}

// MARK: - RegisterAssemblyProtocol
extension RegisterAssembly: RegisterAssemblyProtocol {
	func module() -> UIViewController {
		let view = RegisterViewController()
		let interactor = RegisterInteractor(registeredUserService: registeredUserService,
											noNameUserService: noNameUserService,
											costService: costService)
		let router = RegisterRouter(appCoordinator: appCoordinator)
		let presenter = RegisterPresenter(view: view, interactor: interactor, router: router)

		view.presenter = presenter
		router.viewController = view
		return view
	}
}
