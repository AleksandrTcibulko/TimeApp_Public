//
//  LoginPresenter.swift
//  TimeApp
//
//  Created by Tsibulko on 06.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

protocol LoginPresenterProtocol {
	func loginTapped(with email: String?, _ password: String?)
	func forgotPasswordTapped()
	func goBackTapped()
}

final class LoginPresenter {
	private weak var view: LoginViewControllerProtocol?
	private let interactor: LoginInteractorProtocol
	private let router: LoginRouterProtocol

	init(view: LoginViewControllerProtocol,
		 interactor: LoginInteractorProtocol,
		 router: LoginRouterProtocol) {
		self.view = view
		self.interactor = interactor
		self.router = router
	}
}

// MARK: - LoginPresenterProtocol
extension LoginPresenter: LoginPresenterProtocol {
	func loginTapped(with email: String?, _ password: String?) {
		view?.startSpinnerAnimation()
		interactor.login(with: email, password) { [weak self] result in
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

	func forgotPasswordTapped() {
		router.openResetPasswordModule()
	}

	func goBackTapped() {
		router.goBackToWelcomeModule()
	}
}
