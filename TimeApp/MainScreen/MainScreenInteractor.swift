//
//  MainScreenInteractor.swift
//  TimeApp
//
//  Created by Tsibulko on 27.10.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol MainScreenInteractorProtocol {
	func getSpheres(completion: @escaping ([Sphere]) -> Void)
}

final class MainScreenInteractor {
	private let spheresService: SpheresServiceProtocol

	init(spheresService: SpheresServiceProtocol) {
		self.spheresService = spheresService
	}
}

// MARK: - MainScreenInteractorProtocol
extension MainScreenInteractor: MainScreenInteractorProtocol {
	func getSpheres(completion: @escaping ([Sphere]) -> Void) {
		completion(spheresService.getSpheres())
	}
}
