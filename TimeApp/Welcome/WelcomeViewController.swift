//
//  WelcomeViewController.swift
//  TimeApp
//
//  Created by Tsibulko on 06.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol WelcomeViewControllerProtocol: AnyObject {}

final class WelcomeViewController: UIViewController {
	private let backgroundImageView = UIImageView(image: UIImage(named: "welcome"),
												  contentMode: .scaleAspectFill)
	private let registerButton = UIButton(title: "Зарегистрироваться",
										  target: self,
										  action: #selector(registerButtonTapped),
										  backgroundColor: UIColor.systemBackground.withAlphaComponent(0.9))
	private let loginButton = UIButton(title: "Войти",
									   target: self,
									   action: #selector(loginButtonTapped),
									   backgroundColor: UIColor.systemBackground.withAlphaComponent(0.9))
	private let continueUnknownButton = UIButton(title: "Продолжить без регистрации",
												 target: self,
												 action: #selector(continueUnknownTapped),
												 backgroundColor: UIColor.systemBackground.withAlphaComponent(0.9))

	var presenter: WelcomePresenterProtocol?

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
}

// MARK: - Button Actions
extension WelcomeViewController {
	@objc private func registerButtonTapped() {
		presenter?.registerTapped()
	}

	@objc private func loginButtonTapped() {
		presenter?.loginTapped()
	}

	@objc private func continueUnknownTapped() {
		presenter?.continueUnknownTapped()
	}
}

// MARK: - Private
extension WelcomeViewController {
	private func setupUI() {
		let buttonsStack = UIStackView(arrangedSubviews: [registerButton, loginButton, continueUnknownButton],
									   axis: .vertical,
									   distribution: .fillEqually,
									   alignment: .center,
									   spacing: 10)

		[backgroundImageView, buttonsStack].forEach { view.addSubview($0) }

		NSLayoutConstraint.activate([
			backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
			backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

			buttonsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
			buttonsStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
			buttonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),

			registerButton.widthAnchor.constraint(equalTo: buttonsStack.widthAnchor),
			registerButton.heightAnchor.constraint(equalToConstant: 52),

			loginButton.widthAnchor.constraint(equalTo: buttonsStack.widthAnchor),
			loginButton.heightAnchor.constraint(equalToConstant: 52),

			continueUnknownButton.widthAnchor.constraint(equalTo: buttonsStack.widthAnchor),
			continueUnknownButton.heightAnchor.constraint(equalToConstant: 52)
		])
	}
}

// MARK: - WelcomeViewControllerProtocol
extension WelcomeViewController: WelcomeViewControllerProtocol {}
