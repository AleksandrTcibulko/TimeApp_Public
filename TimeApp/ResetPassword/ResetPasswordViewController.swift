//
//  ResetPasswordViewController.swift
//  TimeApp
//
//  Created by Tsibulko on 29.12.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol ResetPasswordViewControllerProtocol: AnyObject {
	func startSpinnerAnimation()
	func stopSpinnerAnimation()
}

final class ResetPasswordViewController: UIViewController {
	private let backgroundImageView = UIImageView(image: UIImage(named: "mail"),
												  contentMode: .scaleAspectFit)
	private let backgroundScrollView = UIScrollView()
	private let elementsContainer = UIView()
	private let instructionText = UILabel(
		text: "Введите свой email, на него будет выслана инструкция по восстановлению пароля",
		font: .verdana14(),
		numberOfLines: 0,
		textAlignment: .center,
		backgroundColor: .systemBackground.withAlphaComponent(0.98)
	)
	private let emailTextField = RoundedTextField(placeholder: "Email")
	private let sendButton = UIButton(title: "Отправить", target: self, action: #selector(sendButtonTapped))
	private let spinner = UIActivityIndicatorView(style: .large, hidesWhenStopped: true)

	var presenter: ResetPasswordPresenterProtocol?

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		emailTextField.delegate = self
		setupNavigationBar()
		setupUI()
	}

	override func viewDidAppear(_ animated: Bool) {
		addKeyboardStateObserver()
	}

	override func viewDidDisappear(_ animated: Bool) {
		deleteKeyboardStateObserver()
	}
}

// MARK: - Button Actions
extension ResetPasswordViewController {
	@objc private func sendButtonTapped() {
		presenter?.sendTapped(with: emailTextField.text)
	}

	@objc private func goBackButtonTapped() {
		presenter?.goBackTapped()
	}
}

// MARK: - Private
extension ResetPasswordViewController {
	private func setupNavigationBar() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
														   style: .plain,
														   target: self,
														   action: #selector(goBackButtonTapped))
	}

	private func setupUI() {
		let stackView = UIStackView(arrangedSubviews: [instructionText, emailTextField, sendButton],
									axis: .vertical,
									distribution: .fillEqually,
									alignment: .center,
									spacing: 10)

		[backgroundScrollView, elementsContainer].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

		[backgroundImageView, backgroundScrollView].forEach { view.addSubview($0) }
		backgroundScrollView.addSubview(elementsContainer)
		[stackView, spinner].forEach { elementsContainer.addSubview($0) }

		NSLayoutConstraint.activate([
			backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 10),
			backgroundImageView.heightAnchor.constraint(equalToConstant: 150),

			backgroundScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			backgroundScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			backgroundScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			backgroundScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

			elementsContainer.topAnchor.constraint(equalTo: backgroundScrollView.topAnchor),
			elementsContainer.leadingAnchor.constraint(equalTo: backgroundScrollView.leadingAnchor),
			elementsContainer.trailingAnchor.constraint(equalTo: backgroundScrollView.trailingAnchor),
			elementsContainer.bottomAnchor.constraint(equalTo: backgroundScrollView.bottomAnchor),
			elementsContainer.centerXAnchor.constraint(equalTo: backgroundScrollView.centerXAnchor),
			elementsContainer.centerYAnchor.constraint(equalTo: backgroundScrollView.centerYAnchor),

			stackView.bottomAnchor.constraint(equalTo: elementsContainer.safeAreaLayoutGuide.bottomAnchor, constant: -10),
			stackView.widthAnchor.constraint(equalTo: elementsContainer.widthAnchor, multiplier: 0.9),
			stackView.centerXAnchor.constraint(equalTo: elementsContainer.centerXAnchor),

			instructionText.widthAnchor.constraint(equalTo: stackView.widthAnchor),

			emailTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor),
			emailTextField.heightAnchor.constraint(equalToConstant: 52),

			sendButton.widthAnchor.constraint(equalTo: stackView.widthAnchor),
			sendButton.heightAnchor.constraint(equalToConstant: 52),

			spinner.centerXAnchor.constraint(equalTo: elementsContainer.centerXAnchor),
			spinner.centerYAnchor.constraint(equalTo: elementsContainer.centerYAnchor)
		])
	}
}

extension ResetPasswordViewController: ResetPasswordViewControllerProtocol {
	func startSpinnerAnimation() {
		spinner.startAnimating()
	}

	func stopSpinnerAnimation() {
		spinner.stopAnimating()
	}
}

// MARK: - KeyBoard Observer
extension ResetPasswordViewController {
	private func addKeyboardStateObserver() {
		NotificationCenter.default.addObserver(self,
											   selector: #selector(keyboardWillShow),
											   name: UIResponder.keyboardWillShowNotification,
											   object: nil)
		NotificationCenter.default.addObserver(self,
											   selector: #selector(keyboardWillHide),
											   name: UIResponder.keyboardWillHideNotification,
											   object: nil)
	}

	private func deleteKeyboardStateObserver() {
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}

	@objc private func keyboardWillShow(notification: Notification) {
		let userInfo = notification.userInfo
		let keyboardFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		backgroundScrollView.contentOffset = CGPoint(x: 0, y: keyboardFrameSize.height)
	}

	@objc private func keyboardWillHide(notification: NSNotification) {
		backgroundScrollView.contentOffset = CGPoint.zero
	}
}

// MARK: - UITextFieldDelegate
extension ResetPasswordViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch textField {
		case emailTextField:
			view.endEditing(true)
			sendButtonTapped()
		default: break
		}
		return true
	}
}
