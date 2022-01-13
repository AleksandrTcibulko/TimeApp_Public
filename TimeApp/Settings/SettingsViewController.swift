//
//  SettingsViewController.swift
//  TimeApp
//
//  Created by Tsibulko on 13.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol SettingsViewControllerProtocol: AnyObject {
	func update()
	func startSpinnerAnimation()
	func stopSpinnerAnimation()
}

final class SettingsViewController: UIViewController {
	private let warningLabel = UILabel(text: "Зарегистрируйтесь, чтобы не потерять внесенные данные",
									   numberOfLines: 0,
									   textAlignment: .center)
	private let callToShareLabel = UILabel(text: "Расскажите друзьям о приложении",
										   numberOfLines: 0,
										   textAlignment: .center)
	private let registerButton = UIButton(title: "Зарегистрироваться",
										  target: self,
										  action: #selector(registerButtonTapped))
	private let shareButton = UIButton(title: "   Поделиться",
									   target:self,
									   action: #selector(shareButtonTapped),
									   isImage: true)
	private let logOutButton = UIButton(title: "Выйти",
										target: self,
										action: #selector(logOutButtonTapped))
	private let spinner =  UIActivityIndicatorView(style: .large, hidesWhenStopped: true)

	var presenter: SettingsPresenterProtocol?

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
extension SettingsViewController {
	@objc private func registerButtonTapped() {
		presenter?.registerTapped()
	}

	@objc private func shareButtonTapped() {
		presenter?.shareTapped()
	}

	@objc private func logOutButtonTapped() {
		presenter?.logOutTapped()
	}

	@objc private func goBackButtonTapped() {
		presenter?.goBackTapped()
	}
}

// MARK: - Private
extension SettingsViewController {
	private func setupNavigationBar() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
														   style: .plain,
														   target: self,
														   action: #selector(goBackButtonTapped))
	}

	private func setupUI() {
		let callToRegisterStack = UIStackView(arrangedSubviews: [warningLabel, registerButton])
		let callToShareStack = UIStackView(arrangedSubviews: [callToShareLabel, shareButton])
		[callToRegisterStack, callToShareStack].forEach {
			$0.axis = .vertical
			$0.distribution = .fillEqually
			$0.alignment = .center
			$0.spacing = 10
			$0.translatesAutoresizingMaskIntoConstraints = false
		}

		[callToRegisterStack, callToShareStack, logOutButton, spinner].forEach { view.addSubview($0) }

		NSLayoutConstraint.activate([
			callToRegisterStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			callToRegisterStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
			callToRegisterStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),

			warningLabel.widthAnchor.constraint(equalTo: callToRegisterStack.widthAnchor),

			registerButton.widthAnchor.constraint(equalTo: callToRegisterStack.widthAnchor),
			registerButton.heightAnchor.constraint(equalToConstant: 52),

			callToShareStack.topAnchor.constraint(equalTo: callToRegisterStack.bottomAnchor, constant: 20),
			callToShareStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
			callToShareStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),

			callToShareLabel.widthAnchor.constraint(equalTo: callToShareStack.widthAnchor),

			shareButton.widthAnchor.constraint(equalTo: callToShareStack.widthAnchor),
			shareButton.heightAnchor.constraint(equalToConstant: 52),

			logOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
			logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			logOutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
			logOutButton.heightAnchor.constraint(equalToConstant: 52),

			spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}
}

// MARK: - SettingsViewControllerProtocol
extension SettingsViewController: SettingsViewControllerProtocol {
	func update() {
		[warningLabel, registerButton].forEach { $0.isHidden = true }
	}

	func startSpinnerAnimation() {
		spinner.startAnimating()
	}

	func stopSpinnerAnimation() {
		spinner.stopAnimating()
	}
}
