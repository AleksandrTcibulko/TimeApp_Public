//
//  LoginInteractor.swift
//  TimeApp
//
//  Created by Tsibulko on 06.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

protocol LoginInteractorProtocol {
	func login(with email: String?, _ password: String?, completion: @escaping (Result<String, Error>) -> Void)
}

final class LoginInteractor {
	private let registeredUserService: RegisteredUserServiceProtocol

	init(registeredUserService: RegisteredUserServiceProtocol) {
		self.registeredUserService = registeredUserService
	}
}

// MARK: - LoginInteractorProtocol
extension LoginInteractor: LoginInteractorProtocol {
	func login(with email: String?, _ password: String?, completion: @escaping (Result<String, Error>) -> Void) {
		guard let email = email, let password = password, email.isEmpty == false, password.isEmpty == false else {
			completion(.failure(Errors.AuthError.notFilled))
			return
		}
		registeredUserService.login(with: email, password) { result in
			switch result {
			case .success(let userId):
				completion(.success(userId))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
