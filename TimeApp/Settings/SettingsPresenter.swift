//
//  SettingsPresenter.swift
//  TimeApp
//
//  Created by Tsibulko on 13.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

protocol SettingsPresenterProtocol {
	func viewDidLoad()
	func goBackTapped()
	func registerTapped()
	func shareTapped()
	func logOutTapped()
}

final class SettingsPresenter {
	private weak var view: SettingsViewControllerProtocol?
	private let interactor: SettingsInteractorProtocol
	private let router: SettingsRouterProtocol

	init(view: SettingsViewControllerProtocol,
		 interactor: SettingsInteractorProtocol,
		 router: SettingsRouterProtocol) {
		self.view = view
		self.interactor = interactor
		self.router = router
	}
}

// MARK: - SettingsPresenterProtocol
extension SettingsPresenter: SettingsPresenterProtocol {
	func viewDidLoad() {
		if interactor.isUserRegistered {
			view?.update()
		}
	}

	func goBackTapped() {
		router.goBackToMainScreen()
	}
	
	func registerTapped() {
		router.openRegisterModule()
	}

	func shareTapped() {
		router.showShareMenu()
	}

	func logOutTapped() {
		if interactor.isUserRegistered {
			view?.startSpinnerAnimation()
			interactor.logOutRegisteredUser { [weak self] result in
				guard let self = self else { return }
				switch result {
				case .success(_):
					self.view?.stopSpinnerAnimation()
					self.router.openWelcomeModule()
				case .failure(let error):
					self.view?.stopSpinnerAnimation()
					self.router.showAlert(with: error)
				}
			}
		} else {
			router.showBottomSheet { [weak self] shouldLogOut in
				if shouldLogOut {
					guard let self = self else { return }
					self.view?.startSpinnerAnimation()
					self.interactor.logOutNoNameUser { result in
						switch result {
						case .success(_):
							self.view?.stopSpinnerAnimation()
							self.router.openWelcomeModule()
						case .failure(let error):
							self.view?.stopSpinnerAnimation()
							self.router.showAlert(with: error)
						}
					}
				}
			}
		}
	}
}
