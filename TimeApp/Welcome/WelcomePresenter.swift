//
//  WelcomePresenter.swift
//  TimeApp
//
//  Created by Tsibulko on 06.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

protocol WelcomePresenterProtocol {
	func registerTapped()
	func loginTapped()
	func continueUnknownTapped()
}

final class WelcomePresenter {
	private weak var view: WelcomeViewControllerProtocol?
	private let interactor: WelcomeInteractorProtocol
	private let router: WelcomeRouterProtocol

	init(view: WelcomeViewControllerProtocol,
		 interactor: WelcomeInteractorProtocol,
		 router: WelcomeRouterProtocol) {
		self.view = view
		self.interactor = interactor
		self.router = router
	}
}

// MARK: - WelcomePresenterProtocol
extension WelcomePresenter: WelcomePresenterProtocol {
	func registerTapped() {
		router.openRegisterModule()
	}

	func loginTapped() {
		router.openLoginModule()
	}

	func continueUnknownTapped() {
		interactor.createNoNameUser { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let userId):
				self.router.openMainScreen(with: userId)
			case .failure(let error):
				self.router.showAlert(with: error)
			}
		}
	}
}
