//
//  ChooseDateAssembly.swift
//  TimeApp
//
//  Created by Tsibulko on 29.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol ChooseDateAssemblyProtocol {
	func module(with currentDate: Date, completion: @escaping (Date) -> Void) -> UIViewController
}

final class ChooseDateAssembly {
	private let appCoordinator: AppCoordinatorProtocol

	init(appCoordinator: AppCoordinatorProtocol) {
		self.appCoordinator = appCoordinator
	}
}

// MARK: - ChooseDateAssemblyProtocol
extension ChooseDateAssembly: ChooseDateAssemblyProtocol {
	func module(with currentDate: Date, completion: @escaping (Date) -> Void) -> UIViewController {
		let view = ChooseDateViewController()
		let interactor = ChooseDateInteractor()
		let router = ChooseDateRouter(appCoordinator: appCoordinator)
		let presenter = ChooseDatePresenter(view: view,
											interactor:interactor,
											router: router,
											currentDate: currentDate,
											choosedDateHandler: completion)

		view.presenter = presenter
		router.viewController = view
		return view
	}
}
