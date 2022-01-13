//
//  ResetPasswordAssembly.swift
//  TimeApp
//
//  Created by Tsibulko on 29.12.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol ResetPasswordAssemblyProtocol {
	func module() -> UIViewController
}

final class ResetPasswordAssembly {
	private let appCoordinator: AppCoordinatorProtocol
	private let registeredUserService: RegisteredUserServiceProtocol

	init(appCoordinator: AppCoordinatorProtocol,
		 registeredUserService: RegisteredUserServiceProtocol) {
		self.appCoordinator = appCoordinator
		self.registeredUserService = registeredUserService
	}
}

// MARK: - ResetPasswordAssemblyProtocol
extension ResetPasswordAssembly: ResetPasswordAssemblyProtocol {
	func module() -> UIViewController {
		let view = ResetPasswordViewController()
		let interactor = ResetPasswordInteractor(registeredUserService: registeredUserService)
		let router = ResetPasswordRouter(appCoordinator: appCoordinator)
		let presenter = ResetPasswordPresenter(view: view, interactor: interactor, router: router)

		view.presenter = presenter
		router.viewController = view
		return view
	}
}
