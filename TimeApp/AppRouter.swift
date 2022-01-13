//
//  AppRouter.swift
//  TimeApp
//
//  Created by Tsibulko on 17.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol AppRouterProtocol {
	func push(_ viewController: UIViewController)
	func popViewController()
	func set(_ viewController: UIViewController)
}

final class AppRouter {
	private let navigationController: UINavigationController

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
}

//MARK: - AppRouterProtocol
extension AppRouter: AppRouterProtocol {
	func push(_ viewController: UIViewController) {
		navigationController.pushViewController(viewController, animated: true)
	}

	func popViewController() {
		var controllers = navigationController.viewControllers
		controllers.removeLast()
		navigationController.setViewControllers(controllers, animated: true)
	}

	func set(_ viewController: UIViewController) {
		navigationController.setViewControllers([viewController], animated: true)
	}
}
