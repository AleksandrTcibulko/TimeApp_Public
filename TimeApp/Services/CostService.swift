//
//  CostService.swift
//  TimeApp
//
//  Created by Tsibulko on 20.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import Foundation
import Firebase

protocol CostServiceProtocol {
	func save(cost: Cost, completion: @escaping (Result<Void, Error>) -> Void)
	func getCosts(day: Date,
				  userId: String,
				  completion: @escaping (Result<[Cost], Error>) -> Void)
	func remove(cost: Cost, completion: @escaping (Result<Void, Error>) -> Void)

	func saveAll(costs: [Cost], for userId: String, completion: @escaping (Result<Void, Error>) -> Void)
	func getAllCosts(for userId: String, completion: @escaping (Result<[Cost], Error>) -> Void)
}

final class CostService {
	private let database = Firestore.firestore()
}

// MARK: - CostServiceProtocol
extension CostService: CostServiceProtocol {
	func save(cost: Cost, completion: @escaping (Result<Void, Error>) -> Void) {
		guard let date = cost.date.removeTimeComponents() else {
			completion(.failure(Errors.CostError.savingFailed))
			return
		}
		let reference = database.collection("users").document(cost.userId).collection("spendings").document(cost.id)
		reference.setData(
			["userId": cost.userId,
			 "sphere": cost.sphere,
			 "description": cost.description,
			 "spendingInMinutes": cost.spendingInMinutes,
			 "date": Timestamp(date: date)]
		) { error in
			if let error = error {
				completion(.failure(error))
				return
			}
			completion(.success(Void()))
		}
	}

	func getCosts(day: Date,
						  userId: String,
						  completion: @escaping (Result<[Cost], Error>) -> Void) {
		guard let date = day.removeTimeComponents() else {
			completion(.failure(Errors.CostError.getCostsFailed))
			return
		}
		let reference = database.collection("users").document(userId).collection("spendings")
		reference.whereField("date", isEqualTo: Timestamp(date: date)).getDocuments { snapshot, error in
			guard let snapshot = snapshot, error == nil else {
				completion(.failure(Errors.CostError.getCostsFailed))
				return
			}
			let costs = snapshot.documents.map { Cost(document: $0) }.compactMap { $0 }
			completion(.success(costs))
		}
	}

	func remove(cost: Cost, completion: @escaping (Result<Void, Error>) -> Void) {
		let reference = database.collection("users").document(cost.userId).collection("spendings").document(cost.id)
		reference.delete { error in
			if let error = error {
				completion(.failure(error))
				return
			}
			completion(.success(Void()))
		}
	}

	func getAllCosts(for userId: String, completion: @escaping (Result<[Cost], Error>) -> Void) {
		let reference = database.collection("users").document(userId).collection("spendings")
		reference.getDocuments { snapshot, error in
			guard let snapshot = snapshot, error == nil else {
				completion(.failure(Errors.CostError.getCostsFailed))
				return
			}
			let costs = snapshot.documents.map { Cost(document: $0) }.compactMap { $0 }
			completion(.success(costs))
		}
	}

	func saveAll(costs: [Cost], for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
		let queue = DispatchQueue(label: "saveAllCosts", attributes: .concurrent)
		let group = DispatchGroup()
		var isSucceed = true
		let reference = database.collection("users").document(userId).collection("spendings")
		queue.async(group: group) {
			for cost in costs {
				guard let date = cost.date.removeTimeComponents() else {
					isSucceed = false
					completion(.failure(Errors.CostError.savingFailed))
					return
				}
				reference.document(cost.id).setData(
					["userId": userId,
					 "sphere": cost.sphere,
					 "description": cost.description,
					 "spendingInMinutes": cost.spendingInMinutes,
					 "date": Timestamp(date: date)]
				) { error in
					if error != nil {
						isSucceed = false
						completion(.failure(Errors.CostError.savingFailed))
						return
					}
				}
			}
		}
		group.notify(queue: .main) {
			if isSucceed {
				completion(.success(Void()))
			}
		}
	}
}
