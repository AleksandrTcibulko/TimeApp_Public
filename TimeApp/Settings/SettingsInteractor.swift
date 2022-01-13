//
//  SettingsInteractor.swift
//  TimeApp
//
//  Created by Tsibulko on 13.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import Foundation

protocol SettingsInteractorProtocol {
	var isUserRegistered: Bool { get }
	func logOutRegisteredUser(completion: @escaping (Result<Void, Error>) -> Void)
	func logOutNoNameUser(completion: @escaping (Result<Void, Error>) -> Void)
}

final class SettingsInteractor {
	private let noNameUserService: NoNameUserServiceProtocol
	private let registeredUserService: RegisteredUserServiceProtocol

	init(noNameUserService: NoNameUserServiceProtocol,
		 registeredUserService: RegisteredUserServiceProtocol) {
		self.noNameUserService = noNameUserService
		self.registeredUserService = registeredUserService
	}
}

// MARK: - SettingsInteractorProtocol
extension SettingsInteractor: SettingsInteractorProtocol {
	var isUserRegistered: Bool {
		registeredUserService.getUserId() != nil
	}

	func logOutRegisteredUser(completion: @escaping (Result<Void, Error>) -> Void) {
		registeredUserService.logOut { result in
			switch result {
			case .success(_):
				completion(.success(Void()))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	func logOutNoNameUser(completion: @escaping (Result<Void, Error>) -> Void) {
		guard let userId = noNameUserService.getNoNameUser() else {
			completion(.failure(Errors.AuthError.failedToLogOut))
			return
		}
		noNameUserService.removeNoNameUser(id: userId) { result in
			switch result {
			case .success(_):
				completion(.success(Void()))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
