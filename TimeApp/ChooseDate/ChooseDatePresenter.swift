//
//  ChooseDatePresenter.swift
//  TimeApp
//
//  Created by Tsibulko on 29.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import Foundation

protocol ChooseDatePresenterProtocol {
	func viewDidLoad()
	func saveButtonTapped(with date: Date)
	func backButtonTapped()
}

final class ChooseDatePresenter {
	private weak var view: ChooseDateViewControllerProtocol?
	private let interactor: ChooseDateInteractorProtocol
	private let router: ChooseDateRouterProtocol
	private let currentDate: Date
	private let choosedDateHandler: (Date) -> Void

	init(view: ChooseDateViewControllerProtocol,
		 interactor: ChooseDateInteractorProtocol,
		 router: ChooseDateRouterProtocol,
		 currentDate: Date,
		 choosedDateHandler: @escaping (Date) -> Void) {
		self.view = view
		self.interactor = interactor
		self.router = router
		self.currentDate = currentDate
		self.choosedDateHandler = choosedDateHandler
	}
}

// MARK: - ChooseDatePresenterProtocol
extension ChooseDatePresenter: ChooseDatePresenterProtocol {
	func viewDidLoad() {
		view?.updateDatePicker(with: currentDate)
	}

	func saveButtonTapped(with date: Date) {
		choosedDateHandler(date)
		router.goBackToMainScreen()
	}

	func backButtonTapped() {
		router.goBackToMainScreen()
	}
}
