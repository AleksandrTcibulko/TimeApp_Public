//
//  SpheresReportPresenter.swift
//  TimeApp
//
//  Created by Tsibulko on 13.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import Foundation

protocol SpheresReportPresenterProtocol {
	func viewDidLoad()
	func viewWillAppear()
	func openAllCostsReportTapped(for sortedSpheres: [SortedSphere])
	func didTapped(sortedSphere: SortedSphere)
	func backButtonTapped()
}

final class SpheresReportPresenter {
	private weak var view: SpheresReportViewControllerProtocol?
	private let interactor: SpheresReportInteractorProtocol
	private let router: SpheresReportRouterProtocol
	private let userId: String
	private let currentDate: Date

	init(view: SpheresReportViewControllerProtocol,
		 interactor: SpheresReportInteractorProtocol,
		 router: SpheresReportRouterProtocol,
		 userId: String,
		 currentDate: Date) {
		self.view = view
		self.interactor = interactor
		self.router = router
		self.userId = userId
		self.currentDate = currentDate
	}
}

// MARK: - SpheresReportPresenterProtocol
extension SpheresReportPresenter: SpheresReportPresenterProtocol {
	func viewDidLoad() {
		view?.updateTitleView(with: currentDate.convertToString())
	}

	func viewWillAppear() {
		view?.startSpinnerAnimation()
		interactor.getSortedSpheres(for: userId, at: currentDate) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let sortedSpheres):
				DispatchQueue.main.async {
					self.view?.stopSpinnerAnimation()
					self.view?.update(with: sortedSpheres, isEmpty: sortedSpheres.isEmpty)
				}
			case .failure(let error):
				DispatchQueue.main.async {
					self.view?.stopSpinnerAnimation()
					self.router.showAlert(with: error)
				}
			}
		}
	}

	func openAllCostsReportTapped(for sortedSpheres: [SortedSphere]) {
		router.openCostsReport(with: sortedSpheres.flatMap { $0.costs }, at: currentDate)
	}

	func didTapped(sortedSphere: SortedSphere) {
		router.openCostsReport(with: sortedSphere.costs, at: currentDate)
	}

	func backButtonTapped() {
		router.goBackToMainScreen()
	}
}
