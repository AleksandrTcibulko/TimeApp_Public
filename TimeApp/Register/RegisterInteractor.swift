//
//  RegisterInteractor.swift
//  TimeApp
//
//  Created by Tsibulko on 06.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol RegisterInteractorProtocol {
	func register(with email: String?,
				  _ password: String?,
				  completion: @escaping (Result<String, Error>) -> Void)
}

final class RegisterInteractor {
	private let registeredUserService: RegisteredUserServiceProtocol
	private let noNameUserService: NoNameUserServiceProtocol
	private let costService: CostServiceProtocol

	init(registeredUserService: RegisteredUserServiceProtocol,
		 noNameUserService: NoNameUserServiceProtocol,
		 costService: CostServiceProtocol) {
		self.registeredUserService = registeredUserService
		self.noNameUserService = noNameUserService
		self.costService = costService
	}
}

// MARK: - RegisterInteractorProtocol
extension RegisterInteractor: RegisterInteractorProtocol {
	func register(with email: String?,
				  _ password: String?,
				  completion: @escaping (Result<String, Error>) -> Void) {
		guard let email = email, let password = password, email.isEmpty == false, password.isEmpty == false else {
			completion(.failure(Errors.AuthError.notFilled))
			return
		}
		guard password.count >= 6 else {
			completion(.failure(Errors.AuthError.invalidPassword))
			return
		}
		guard email.isValidEmail() else {
			completion(.failure(Errors.AuthError.invalidEmail))
			return
		}
		registeredUserService.isUserExists(email: email) { [weak self] isUserExists in
			guard let self = self else { return }
			if isUserExists {
				completion(.failure(Errors.AuthError.userAlreadyExists))
			} else {
				self.registeredUserService.register(with: email, password) { result in
					switch result {
					case .success(let registeredUser):
						let noNameUserId = self.noNameUserService.getNoNameUser()
						if let noNameUserId = noNameUserId {
							self.rebaseUsersData(from: noNameUserId, to: registeredUser.uid) { result in
								switch result {
								case .success():
									completion(.success(registeredUser.uid))
								case .failure(let error):
									self.registeredUserService.remove(user: registeredUser)
									completion(.failure(error))
								}
							}
						} else {
							completion(.success(registeredUser.uid))
						}
					case .failure(let error):
						completion(.failure(error))
					}
				}
			}
		}
	}
}

// MARK: - Private
extension RegisterInteractor {
	private func rebaseUsersData(from noNameUser: String,
								 to registeredUser: String,
								 completion: @escaping (Result<Void, Error>) -> Void) {
		costService.getAllCosts(for: noNameUser) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let costs):
				self.costService.saveAll(costs: costs, for: registeredUser) { result in
					switch result {
					case .success():
						self.noNameUserService.removeNoNameUser(id: noNameUser) { result in
							switch result {
							case .success():
								completion(.success(Void()))
							case .failure(let error):
								completion(.failure(error))
							}
						}
					case .failure(let error):
						completion(.failure(error))
					}
				}
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}

private extension String {
	func isValidEmail() -> Bool {
		let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
		return emailPredicate.evaluate(with: self)
	}
}
