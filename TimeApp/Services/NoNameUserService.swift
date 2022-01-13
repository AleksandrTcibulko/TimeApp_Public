//
//  NoNameUserService.swift
//  TimeApp
//
//  Created by Tsibulko on 06.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import Foundation

protocol NoNameUserServiceProtocol {
	func createNoNameUser(id: String, completion: @escaping (Result<Void, Error>) -> Void)
	func getNoNameUser() -> String?
	func removeNoNameUser(id: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class NoNameUserService {
	private let firestoreUsersDataService: FirestoreUsersDataServiceProtocol
	private let defaults = UserDefaults.standard
	private let noNameUserIdKey = "noNameUserIdKey"

	init(firestoreUsersDataService: FirestoreUsersDataServiceProtocol) {
		self.firestoreUsersDataService = firestoreUsersDataService
	}
}

// MARK: - NoNameUserServiceProtocol
extension NoNameUserService: NoNameUserServiceProtocol {
	func createNoNameUser(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
		firestoreUsersDataService.addUser(id: id, email: "") { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success():
				self.defaults.set(id, forKey: self.noNameUserIdKey)
				completion(.success(Void()))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	func getNoNameUser() -> String? {
		defaults.value(forKey: noNameUserIdKey) as? String
	}

	func removeNoNameUser(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
		firestoreUsersDataService.removeUser(id: id) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success():
				self.defaults.removeObject(forKey: self.noNameUserIdKey)
				completion(.success(Void()))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
