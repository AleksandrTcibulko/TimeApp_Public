//
//  SettingsRouter.swift
//  TimeApp
//
//  Created by Tsibulko on 13.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol SettingsRouterProtocol {
	func goBackToMainScreen()
	func openRegisterModule()
	func openWelcomeModule()
	func showShareMenu()
	func showAlert(with error: Error)
	func showBottomSheet(completion: @escaping (Bool) -> Void)
}

final class SettingsRouter {
	weak var viewController: UIViewController?
	private let appCoordinator: AppCoordinatorProtocol

	init(appCoordinator: AppCoordinatorProtocol) {
		self.appCoordinator = appCoordinator
	}
}

// MARK: - SettingsRouterProtocol
extension SettingsRouter: SettingsRouterProtocol {
	func goBackToMainScreen() {
		appCoordinator.dismissCurrentModule()
	}
	
	func openRegisterModule() {
		appCoordinator.openRegisterModule()
	}

	func openWelcomeModule() {
		appCoordinator.openWelcomeModule()
	}

	func showShareMenu() {
		let appStoreLink = "https://apps.apple.com/ru/app/%D0%B5%D1%81%D1%82%D1%8C-%D0%B2%D1%80%D0%B5%D0%BC%D1%8F/id1537228967"
		let shareController = UIActivityViewController(activityItems: [appStoreLink], applicationActivities: nil)
		viewController?.present(shareController, animated: true, completion: nil)
	}

	func showAlert(with error: Error) {
		viewController?.showAlert(with: AlertModel(message: error.localizedDescription),
								  completion: { [weak self] in
			guard let self = self else { return }
			self.viewController?.dismiss(animated: true, completion: nil)
		})
	}

	func showBottomSheet(completion: @escaping (Bool) -> Void) {
		let alertController = UIAlertController(title: "Вы уверены, что хотите выйти?",
												message: "Все данные будут удалены без возможности восстановления",
												preferredStyle: .actionSheet)
		alertController.view.tintColor = .label
		alertController.addAction(UIAlertAction(title: "Выйти", style: .default, handler: { [weak self] action in
			guard let self = self else { return }
			self.viewController?.dismiss(animated: true, completion: {
				completion(true)
			})
		}))
		alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { [ weak self ] action in
			guard let self = self else { return }
			self.viewController?.dismiss(animated: true, completion: {
				completion(false)
			})
		}))
		viewController?.present(alertController, animated: true)
	}
}
