//
//  CostViewController.swift
//  TimeApp
//
//  Created by Tsibulko on 04.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol CostViewControllerProtocol: AnyObject {}

final class CostViewController: UIViewController {
	private let descriptionContainerView = UIView(backgroundColor: #colorLiteral(red: 0.7882352941, green: 0.9254901961, blue: 0.8980392157, alpha: 1), clipsToBounds: true, isShadow: true)
	private let descriptionTextViewPlaceholder = "Напишите, чем занимались"
	private let descriptionTextView = UITextView(placeholder: "")
	private let spendedTimeContainerView = UIView(backgroundColor: #colorLiteral(red: 0.7882352941, green: 0.9254901961, blue: 0.8980392157, alpha: 1), clipsToBounds: true, isShadow: true)
	private let spendedTimeTitleLabel = UILabel(text: "Сколько времени потратили?")
	private let hoursLabel = UILabel(text: "Часы", textAlignment: .center)
	private let hoursTextField = RoundedTextField(placeholder: "00",
												  textAlignment: .center,
												  backgroundColor: .systemBackground,
												  keyboardType: .decimalPad,
												  textFieldInputType: .hours)
	private let minutesLabel = UILabel(text: "Минуты", textAlignment: .center)
	private let minutesTextField = RoundedTextField(placeholder: "00",
													textAlignment: .center,
													backgroundColor: .systemBackground,
													keyboardType: .decimalPad,
													textFieldInputType: .minutes)
	private let createCostButton = UIButton(title: "Добавить",
													target: self,
													action: #selector(createCostTapped))

	var presenter: CostPresenterProtocol?

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		hoursTextField.delegate = self
		minutesTextField.delegate = self
		setupNavigationBar()
		setupDescriptionTextView()
		setupUI()
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		view.endEditing(true)
	}

	// MARK: - Button Action
	@objc private func createCostTapped() {
		presenter?.createCostTapped(with: descriptionTextView.text,
											hours: hoursTextField.text,
											minutes: minutesTextField.text)
	}

	@objc private func backButtonTapped() {
		presenter?.backButtonTapped()
	}
}

// MARK: - Private
extension CostViewController {
	private func setupNavigationBar() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
														   style: .plain,
														   target: self,
														   action: #selector(backButtonTapped))
	}

	private func setupDescriptionTextView() {
		descriptionTextView.delegate = self
		descriptionTextView.text = descriptionTextViewPlaceholder
		descriptionTextView.textColor = UIColor.lightGray
	}

	private func setupUI() {
		let hoursStack = UIStackView(arrangedSubviews: [hoursTextField, hoursLabel])
		let minutesStack = UIStackView(arrangedSubviews: [minutesTextField, minutesLabel])
		[hoursStack, minutesStack].forEach {
			$0.axis = .vertical
			$0.distribution = .fill
			$0.alignment = .center
			$0.spacing = 0
			$0.translatesAutoresizingMaskIntoConstraints = false
		}
		let timeInputStack = UIStackView(arrangedSubviews: [hoursStack, minutesStack],
										 axis: .horizontal,
										 distribution: .fillEqually,
										 alignment: .center,
										 spacing: 10)
		let timeInputStackWithTitle = UIStackView(arrangedSubviews: [spendedTimeTitleLabel, timeInputStack],
												  axis: .vertical,
												  distribution: .fill,
												  alignment: .leading,
												  spacing: 0)

		descriptionContainerView.addSubview(descriptionTextView)
		spendedTimeContainerView.addSubview(timeInputStackWithTitle)
		[descriptionContainerView, spendedTimeContainerView, createCostButton].forEach { view.addSubview($0) }

		NSLayoutConstraint.activate([
			descriptionContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			descriptionContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			descriptionContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
			descriptionContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),

			descriptionTextView.widthAnchor.constraint(equalTo: descriptionContainerView.widthAnchor, multiplier: 0.9),
			descriptionTextView.heightAnchor.constraint(equalTo: descriptionContainerView.heightAnchor, multiplier: 0.8),
			descriptionTextView.centerXAnchor.constraint(equalTo: descriptionContainerView.centerXAnchor),
			descriptionTextView.centerYAnchor.constraint(equalTo: descriptionContainerView.centerYAnchor),

			spendedTimeContainerView.topAnchor.constraint(equalTo: descriptionContainerView.bottomAnchor, constant: 10),
			spendedTimeContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			spendedTimeContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
			spendedTimeContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),

			timeInputStackWithTitle.widthAnchor.constraint(equalTo: spendedTimeContainerView.widthAnchor, multiplier: 0.9),
			timeInputStackWithTitle.heightAnchor.constraint(equalTo: spendedTimeContainerView.heightAnchor, multiplier: 0.9),
			timeInputStackWithTitle.centerXAnchor.constraint(equalTo: spendedTimeContainerView.centerXAnchor),
			timeInputStackWithTitle.centerYAnchor.constraint(equalTo: spendedTimeContainerView.centerYAnchor),

			timeInputStack.widthAnchor.constraint(equalTo: timeInputStackWithTitle.widthAnchor),
			timeInputStack.heightAnchor.constraint(equalTo: timeInputStackWithTitle.heightAnchor, multiplier: 0.7),

			hoursStack.heightAnchor.constraint(equalTo: timeInputStack.heightAnchor, multiplier: 0.8),

			minutesStack.heightAnchor.constraint(equalTo: timeInputStack.heightAnchor, multiplier: 0.8),

			hoursTextField.heightAnchor.constraint(equalToConstant: 52),
			hoursTextField.widthAnchor.constraint(equalTo: hoursStack.widthAnchor, multiplier: 0.9),

			minutesTextField.heightAnchor.constraint(equalToConstant: 52),
			minutesTextField.widthAnchor.constraint(equalTo: hoursStack.widthAnchor, multiplier: 0.9),

			createCostButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
			createCostButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			createCostButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
			createCostButton.heightAnchor.constraint(equalToConstant: 52)
		])
	}
}

// MARK: - UITextViewDelegate
extension CostViewController: UITextViewDelegate {

	func textViewDidChangeSelection(_ textView: UITextView) {
		if textView.text == descriptionTextViewPlaceholder {
			textView.selectedRange = NSRange(location: 0, length: 0)
		}
	}

	func textViewDidChange(_ textView: UITextView) {
		if textView.text.isEmpty {
			textView.text = descriptionTextViewPlaceholder
			textView.textColor = .lightGray
		} else if textView.text != descriptionTextViewPlaceholder {
			textView.textColor = .black
		}
	}

	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if textView.text == descriptionTextViewPlaceholder {
			textView.text = ""
		}

		if text.count > 100 {
			return false
		}

		let existingLines = textView.text.components(separatedBy: CharacterSet.newlines)
		let newLines = text.components(separatedBy: CharacterSet.newlines)
		let linesAfterChange = existingLines.count + newLines.count - 1
		if linesAfterChange > textView.textContainer.maximumNumberOfLines {
			return false
		}

		let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
		let numberOfChars = newText.count
		if numberOfChars > 100 {
			return false
		}

		return true
	}
}

// MARK: - UITextFieldDelegate
extension CostViewController: UITextFieldDelegate {
	func textField(_ textField: UITextField,
				   shouldChangeCharactersIn range: NSRange,
				   replacementString string: String) -> Bool {
		presenter?.shouldChange(textField, in: range, with: string) ?? false
	}
}

// MARK: - CostViewControllerProtocol
extension CostViewController: CostViewControllerProtocol {}
