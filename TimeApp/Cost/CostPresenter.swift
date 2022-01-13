//
//  CostPresenter.swift
//  TimeApp
//
//  Created by Tsibulko on 05.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

protocol CostPresenterProtocol {
	func createCostTapped(with description: String?, hours: String?, minutes: String?)
	func backButtonTapped()
	func shouldChange(_ textField: UITextField, in range: NSRange, with string: String) -> Bool
}

final class CostPresenter {
	private weak var view: CostViewControllerProtocol?
	private let interactor: CostInteractorProtocol
	private let router: CostRouterProtocol

	init(view: CostViewControllerProtocol,
		 interactor: CostInteractorProtocol,
		 router: CostRouterProtocol) {
		self.view = view
		self.interactor = interactor
		self.router = router
	}
}

// MARK: - CostPresenterProtocol
extension CostPresenter: CostPresenterProtocol {
	func createCostTapped(with description: String?, hours: String?, minutes: String?) {
		interactor.createCost(with: description, hours: hours, minutes: minutes) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success():
				self.router.goBackToMainViewController()
			case .failure(let error):
				self.router.showAlert(with: error)
			}
		}
	}

	func backButtonTapped() {
		router.goBackToMainViewController()
	}

	func shouldChange(_ textField: UITextField, in range: NSRange, with string: String) -> Bool {
		guard let roundedTextField = textField as? RoundedTextField else { return false }
		return interactor.validateInput(at: roundedTextField, in: range, with: string)
	}
}
