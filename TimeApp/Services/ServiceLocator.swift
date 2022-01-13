//
//  ServiceLocator.swift
//  TimeApp
//
//  Created by Tsibulko on 16.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

protocol ServiceLocatorProtocol: AnyObject {
	var spheresService: SpheresServiceProtocol { get }
	var noNameUserService: NoNameUserServiceProtocol { get }
	var registeredUserService: RegisteredUserServiceProtocol { get }
	var costService: CostServiceProtocol { get }
	var firestoreUsersDataService: FirestoreUsersDataServiceProtocol { get }
}

final class ServiceLocator: ServiceLocatorProtocol {
	lazy var spheresService: SpheresServiceProtocol = SpheresService()
	lazy var firestoreUsersDataService: FirestoreUsersDataServiceProtocol = FirestoreUsersDataService()
	lazy var noNameUserService: NoNameUserServiceProtocol = NoNameUserService(
		firestoreUsersDataService: firestoreUsersDataService
	)
	lazy var registeredUserService: RegisteredUserServiceProtocol = RegisteredUserService(
		firestoreUsersDataService: firestoreUsersDataService
	)
	lazy var costService: CostServiceProtocol = CostService()
}
