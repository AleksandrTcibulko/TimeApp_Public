//
//  RegisterPresenter.swift
//  TimeApp
//
//  Created by Tsibulko on 06.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

protocol RegisterPresenterProtocol {
	func registerTapped(with email: String?, _ password: String?)
	func goBackTapped()
}

final class RegisterPresenter {
	private weak var view: RegisterViewControllerProtocol?
	private let interactor: RegisterInteractorProtocol
	private let router: RegisterRouterProtocol

	init(view: RegisterViewControllerProtocol,
		 interactor: RegisterInteractorProtocol,
		 router: RegisterRouterProtocol) {
		self.view = view
		self.interactor = interactor
		self.router = router
	}
}

// MARK: - RegisterPresenterProtocol
extension RegisterPresenter: RegisterPresenterProtocol {
	func registerTapped(with email: String?, _ password: String?) {
		view?.startSpinnerAnimation()
		interactor.register(with: email, password) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let userId):
				self.view?.stopSpinnerAnimation()
				self.router.openMainScreen(with: userId)
			case .failure(let error):
				self.view?.stopSpinnerAnimation()
				self.router.showAlert(with: error)
			}
		}
	}

	func goBackTapped() {
		router.goBackToWelcomeModule()
	}
}
