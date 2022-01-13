//
//  AppCoordinator.swift
//  TimeApp
//
//  Created by Tsibulko on 16.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol AppCoordinatorProtocol {
	func start()
	func openMainScreenModule(with userId: String)
	func openWelcomeModule()
	func openRegisterModule()
	func openLoginModule()
	func openResetPasswordModule()
	func openCostModule(with costCreationInfo: CostCreationInfo)
	func openSpheresReportModule(for userId: String, at date: Date)
	func openCostsReportModule(with costs: [Cost], at date: Date)
	func openSettingsModule()
	func openChooseDateModule(with currentDate: Date, completion: @escaping (Date) -> Void)
	func dismissCurrentModule()
}

final class AppCoordinator {
	private let appRouter: AppRouterProtocol
	private let serviceLocator: ServiceLocator

	init(appRouter: AppRouterProtocol, serviceLocator: ServiceLocator) {
		self.appRouter = appRouter
		self.serviceLocator = serviceLocator
	}
}

// MARK: - CoordinatorProtocol
extension AppCoordinator: AppCoordinatorProtocol {
	func start() {
		openStartScreen(according: getUserStatus())
	}

	func openMainScreenModule(with userId: String) {
		startFromMainScreenModule(with: userId)
	}

	func openWelcomeModule() {
		startFromWelcomeModule()
	}

	func openRegisterModule() {
		let viewController = RegisterAssembly(
			appCoordinator: self,
			registeredUserService: serviceLocator.registeredUserService,
			noNameUserService: serviceLocator.noNameUserService,
			costService: serviceLocator.costService
		).module()
		appRouter.push(viewController)
	}

	func openLoginModule() {
		let viewController = LoginAssembly(
			appCoordinator: self,
			registeredUserService: serviceLocator.registeredUserService
		).module()
		appRouter.push(viewController)
	}

	func openResetPasswordModule() {
		let viewController = ResetPasswordAssembly(
			appCoordinator: self,
			registeredUserService: serviceLocator.registeredUserService
		).module()
		appRouter.push(viewController)
	}

	func openCostModule(with costCreationInfo: CostCreationInfo) {
		let viewController = CostAssembly(
			appCoordinator: self,
			costService: serviceLocator.costService
		).module(with: costCreationInfo)
		appRouter.push(viewController)
	}

	func openSpheresReportModule(for userId: String, at date: Date) {
		let viewController = SpheresReportAssembly(
			appCoordinator: self,
			costService: serviceLocator.costService
		).module(with: userId, date: date)
		appRouter.push(viewController)
	}

	func openCostsReportModule(with costs: [Cost], at date: Date) {
		let viewController = CostsReportAssembly(
			appCoordinator: self,
			costService: serviceLocator.costService
		).module(with: costs, day: date)
		appRouter.push(viewController)
	}

	func openSettingsModule() {
		let viewController = SettingsAssembly(
			appCoordinator: self,
			noNameUserService: serviceLocator.noNameUserService,
			registeredUserService: serviceLocator.registeredUserService
		).module()
		appRouter.push(viewController)
	}

	func openChooseDateModule(with currentDate: Date, completion: @escaping (Date) -> Void) {
		let viewController = ChooseDateAssembly(appCoordinator: self).module(with: currentDate, completion: completion)
		appRouter.push(viewController)
	}

	func dismissCurrentModule() {
		appRouter.popViewController()
	}
}

// MARK: - Private
extension AppCoordinator {
	private enum UserStatus {
		case registered(userId: String)
		case noName(userId: String)
		case new
	}

	private func getUserStatus() -> UserStatus {
		if let userId = serviceLocator.registeredUserService.getUserId() {
			return .registered(userId: userId)
		} else if let userId = serviceLocator.noNameUserService.getNoNameUser() {
			return .noName(userId: userId)
		} else {
			return .new
		}
	}

	private func openStartScreen(according userStatus: UserStatus) {
		switch userStatus {
		case .registered(let userId):
			startFromMainScreenModule(with: userId)
		case .noName(let userId):
			startFromMainScreenModule(with: userId)
		case .new:
			startFromWelcomeModule()
		}
	}

	private func startFromMainScreenModule(with userId: String) {
		let viewController = MainScreenAssembly(
			appCoordinator: self, spheresService: serviceLocator.spheresService
		).module(with: userId)
		appRouter.set(viewController)
	}

	private func startFromWelcomeModule() {
		let viewController = WelcomeAssembly(appCoordinator: self,
											 noNameUserService: serviceLocator.noNameUserService).module()
		appRouter.set(viewController)
	}
}
