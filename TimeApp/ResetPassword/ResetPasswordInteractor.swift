//
//  ResetPasswordInteractor.swift
//  TimeApp
//
//  Created by Tsibulko on 29.12.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

protocol ResetPasswordInteractorProtocol {
	func sendResetPassword(to email: String?, completion: @escaping (Result<Void, Error>) -> Void)
}

final class ResetPasswordInteractor {
	private let registeredUserService: RegisteredUserServiceProtocol

	init(registeredUserService: RegisteredUserServiceProtocol) {
		self.registeredUserService = registeredUserService
	}
}

// MARK: - ResetPasswordInteractorProtocol
extension ResetPasswordInteractor: ResetPasswordInteractorProtocol {
	func sendResetPassword(to email: String?, completion: @escaping (Result<Void, Error>) -> Void) {
		guard let email = email, !email.isEmpty else {
			completion(.failure(Errors.AuthError.emailNotFilled))
			return
		}
		registeredUserService.sendResetPassword(to: email) { result in
			switch result {
			case .success():
				completion(.success(Void()))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
