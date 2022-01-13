//
//  ResetPasswordPresenter.swift
//  TimeApp
//
//  Created by Tsibulko on 29.12.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import SwiftUI

protocol ResetPasswordPresenterProtocol {
	func goBackTapped()
	func sendTapped(with email: String?)
}

final class ResetPasswordPresenter {
	private weak var view: ResetPasswordViewControllerProtocol?
	private let interactor: ResetPasswordInteractorProtocol
	private let router: ResetPasswordRouterProtocol

	init(view: ResetPasswordViewControllerProtocol,
		 interactor: ResetPasswordInteractorProtocol,
		 router: ResetPasswordRouterProtocol) {
		self.view = view
		self.interactor = interactor
		self.router = router
	}
}

// MARK: - ResetPasswordPresenterProtocol
extension ResetPasswordPresenter: ResetPasswordPresenterProtocol {
	func goBackTapped() {
		router.goBackToLoginModule()
	}

	func sendTapped(with email: String?) {
		view?.startSpinnerAnimation()
		interactor.sendResetPassword(to: email) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success():
				self.view?.stopSpinnerAnimation()
				self.router.showSuccessAlertAndDismissModule()
			case .failure(let error):
				self.view?.stopSpinnerAnimation()
				self.router.showAlert(with: error)
			}
		}
	}
}
