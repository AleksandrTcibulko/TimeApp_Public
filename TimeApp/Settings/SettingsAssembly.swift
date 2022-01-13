//
//  SettingsAssembly.swift
//  TimeApp
//
//  Created by Tsibulko on 13.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol SettingsAssemblyProtocol {
	func module() -> UIViewController
}

final class SettingsAssembly {
	private let appCoordinator: AppCoordinatorProtocol
	private let noNameUserService: NoNameUserServiceProtocol
	private let registeredUserService: RegisteredUserServiceProtocol

	init(appCoordinator: AppCoordinatorProtocol,
		 noNameUserService: NoNameUserServiceProtocol,
		 registeredUserService: RegisteredUserServiceProtocol) {
		self.appCoordinator = appCoordinator
		self.noNameUserService = noNameUserService
		self.registeredUserService = registeredUserService
	}
}

// MARK: - SettingsAssemblyProtocol
extension SettingsAssembly: SettingsAssemblyProtocol {
	func module() -> UIViewController {
		let view = SettingsViewController()
		let interactor = SettingsInteractor(noNameUserService: noNameUserService,
											registeredUserService: registeredUserService)
		let router = SettingsRouter(appCoordinator: appCoordinator)
		let presenter = SettingsPresenter(view: view, interactor: interactor, router: router)

		view.presenter = presenter
		router.viewController = view
		return view
	}
}
