//
//  ChooseDateRouter.swift
//  TimeApp
//
//  Created by Tsibulko on 29.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol ChooseDateRouterProtocol {
	func goBackToMainScreen()
}

final class ChooseDateRouter {
	weak var viewController: UIViewController?
	private let appCoordinator: AppCoordinatorProtocol

	init(appCoordinator: AppCoordinatorProtocol) {
		self.appCoordinator = appCoordinator
	}
}

// MARK: - ChooseDateRouterProtocol
extension ChooseDateRouter: ChooseDateRouterProtocol {
	func goBackToMainScreen() {
		appCoordinator.dismissCurrentModule()
	}
}
