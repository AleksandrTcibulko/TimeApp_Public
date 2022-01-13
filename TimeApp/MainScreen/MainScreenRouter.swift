//
//  MainScreenRouter.swift
//  TimeApp
//
//  Created by Tsibulko on 27.10.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol MainScreenRouterProtocol {
	func openSettings()
	func openSpheresReport(for userId: String, at date: Date)
	func openCreationCost(with costCreationInfo: CostCreationInfo)
	func openChooseDateModule(with currentDate: Date, completion: @escaping (Date) -> Void)
}

final class MainScreenRouter {
	weak var viewController: UIViewController?
	private let appCoordinator: AppCoordinatorProtocol

	init(appCoordinator: AppCoordinatorProtocol) {
		self.appCoordinator = appCoordinator
	}
}

// MARK: - MainScreenRouterProtocol
extension MainScreenRouter: MainScreenRouterProtocol {
	func openSettings() {
		appCoordinator.openSettingsModule()
	}

	func openSpheresReport(for userId: String, at date: Date) {
		appCoordinator.openSpheresReportModule(for: userId, at: date)
	}

	func openCreationCost(with costCreationInfo: CostCreationInfo) {
		appCoordinator.openCostModule(with: costCreationInfo)
	}

	func openChooseDateModule(with currentDate: Date, completion: @escaping (Date) -> Void) {
		appCoordinator.openChooseDateModule(with: currentDate, completion: completion)
	}
}
