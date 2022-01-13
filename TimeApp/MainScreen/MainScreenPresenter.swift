//
//  MainScreenPresenter.swift
//  TimeApp
//
//  Created by Tsibulko on 27.10.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import Foundation

protocol MainScreenPresenterProtocol {
	func viewDidLoad()
	func currentDateButtonTapped()
	func settingsButtonTapped()
	func didTapped(sphere: Sphere, at indexPath: IndexPath)
	func openDayBySpheresTapped()
}

final class MainScreenPresenter {
	private weak var view: MainScreenViewControllerProtocol?
	private let interactor: MainScreenInteractorProtocol
	private let router: MainScreenRouterProtocol

	private let userId: String
	private var currentDate = Date()

	init(view: MainScreenViewControllerProtocol,
		 interactor: MainScreenInteractorProtocol,
		 router: MainScreenRouterProtocol,
		 userId: String) {
		self.view = view
		self.interactor = interactor
		self.router = router
		self.userId = userId
	}
}

// MARK: - MainScreenPresenterProtocol
extension MainScreenPresenter: MainScreenPresenterProtocol {
	func viewDidLoad() {
		interactor.getSpheres { [weak self] spheres in
			guard let self = self else { return }
			DispatchQueue.main.async {
				self.view?.update(with: spheres, and: self.currentDate.convertToString())
			}
		}
	}

	func currentDateButtonTapped() {
		router.openChooseDateModule(with: currentDate) { [weak self] choosedDate in
			guard let self = self else { return }
			self.currentDate = choosedDate
			DispatchQueue.main.async {
				self.view?.updateTitle(with: choosedDate.convertToString())
			}
		}
	}

	func settingsButtonTapped() {
		router.openSettings()
	}

	func didTapped(sphere: Sphere, at indexPath: IndexPath) {
		view?.animateCellTap(at: indexPath)
		router.openCreationCost(with: CostCreationInfo(userId: userId, sphere: sphere.title, date: currentDate))
	}

	func openDayBySpheresTapped() {
		router.openSpheresReport(for: userId, at: currentDate)
	}
}
