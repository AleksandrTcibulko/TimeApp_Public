//
//  WelcomeInteractor.swift
//  TimeApp
//
//  Created by Tsibulko on 06.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import Foundation

protocol WelcomeInteractorProtocol {
	func createNoNameUser(completion: @escaping (Result<String, Error>) -> Void)
}

final class WelcomeInteractor {
	private let noNameUserService: NoNameUserServiceProtocol

	init(noNameUserService: NoNameUserServiceProtocol) {
		self.noNameUserService = noNameUserService
	}
}

// MARK: - WelcomeInteractorProtocol
extension WelcomeInteractor: WelcomeInteractorProtocol {
	func createNoNameUser(completion: @escaping (Result<String, Error>) -> Void) {
		let noNameUserId = UUID().uuidString
		noNameUserService.createNoNameUser(id: noNameUserId) { result in
			switch result {
			case .success():
				completion(.success(noNameUserId))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
