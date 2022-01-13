//
//  ChooseDateViewController.swift
//  TimeApp
//
//  Created by Tsibulko on 29.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol ChooseDateViewControllerProtocol: AnyObject {
	func updateDatePicker(with date: Date)
}

final class ChooseDateViewController: UIViewController {
	private let datePicker: UIDatePicker = {
		let picker = UIDatePicker()
		picker.tintColor = .black
		picker.datePickerMode = .date
		picker.locale = Locale(identifier: "ru_RU")
		picker.translatesAutoresizingMaskIntoConstraints = false
		return picker
	}()

	private let saveButton = UIButton(title: "Сохранить",
									  target: self,
									  action: #selector(saveButtonTapped))

	var presenter: ChooseDatePresenterProtocol?

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		presenter?.viewDidLoad()
		setupNavigationBar()
		setupUI()
	}
}

// MARK: - Button Actions
extension ChooseDateViewController {
	@objc private func saveButtonTapped() {
		presenter?.saveButtonTapped(with: datePicker.date)
	}

	@objc private func backButtonTapped() {
		presenter?.backButtonTapped()
	}
}

// MARK: - Private
extension ChooseDateViewController {
	private func setupNavigationBar() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
														   style: .plain,
														   target: self,
														   action: #selector(backButtonTapped))
	}

	private func setupUI() {
		[datePicker, saveButton].forEach { view.addSubview($0) }

		NSLayoutConstraint.activate([
			datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor),

			saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
			saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
			saveButton.heightAnchor.constraint(equalToConstant: 52)
		])
	}
}

// MARK: - ChooseDateViewControllerProtocol
extension ChooseDateViewController: ChooseDateViewControllerProtocol{
	func updateDatePicker(with date: Date) {
		datePicker.date = date
	}
}
