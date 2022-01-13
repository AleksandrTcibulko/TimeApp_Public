//
//  LoginAssembly.swift
//  TimeApp
//
//  Created by Tsibulko on 06.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol LoginAssemblyProtocol {
	func module() -> UIViewController
}

final class LoginAssembly {
	private let appCoordinator: AppCoordinatorProtocol
	private let registeredUserService: RegisteredUserServiceProtocol

	init(appCoordinator: AppCoordinatorProtocol,
		 registeredUserService: RegisteredUserServiceProtocol) {
		self.appCoordinator = appCoordinator
		self.registeredUserService = registeredUserService
	}
}

// MARK: - LoginAssemblyProtocol
extension LoginAssembly: LoginAssemblyProtocol {
	func module() -> UIViewController {
		let view = LoginViewController()
		let interactor = LoginInteractor(registeredUserService: registeredUserService)
		let router = LoginRouter(appCoordinator: appCoordinator)
		let presenter = LoginPresenter(view: view, interactor: interactor, router: router)

		view.presenter = presenter
		router.viewController = view
		return view
	}
}
