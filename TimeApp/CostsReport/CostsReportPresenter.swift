//
//  CostsReportPresenter.swift
//  TimeApp
//
//  Created by Tsibulko on 13.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import Foundation

protocol CostsReportPresenterProtocol {
	func viewDidLoad()
	func swipedToRemove(cost: Cost?)
	func backButtonTapped()
}

final class CostsReportPresenter {
	private weak var view: CostsReportViewControllerProtocol?
	private let interactor: CostsReportInteractorProtocol
	private let router: CostsReportRouterProtocol
	private let day: Date

	init(view: CostsReportViewControllerProtocol,
		 interactor: CostsReportInteractorProtocol,
		 router: CostsReportRouterProtocol,
		 day: Date) {
		self.view = view
		self.interactor = interactor
		self.router = router
		self.day = day
	}
}

// MARK: - CostsReportPresenterProtocol
extension CostsReportPresenter: CostsReportPresenterProtocol {
	func viewDidLoad() {
		interactor.getSortedCosts() { [weak self] sortedCosts in
			guard let self = self else { return }
			self.view?.update(with: sortedCosts, date: self.day.convertToString())
		}
	}

	func swipedToRemove(cost: Cost?) {
		interactor.remove(cost: cost) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success():
				self.interactor.getSortedCosts() { sortedCosts in
					DispatchQueue.main.async {
						self.view?.update(with: sortedCosts, date: self.day.convertToString())
					}
				}
			case .failure(let error):
				self.router.showAlert(with: error)
			}
		}
	}

	func backButtonTapped() {
		router.goBackToDayBySpheresViewController()
	}
}
