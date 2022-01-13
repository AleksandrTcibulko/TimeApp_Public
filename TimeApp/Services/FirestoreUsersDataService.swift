//
//  FirestoreUsersDataService.swift
//  TimeApp
//
//  Created by Tsibulko on 06.12.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import Foundation
import Firebase

protocol FirestoreUsersDataServiceProtocol {
	func isUserExists(email: String, completion: @escaping ((Bool) -> Void))
	func addUser(id: String, email: String, completion: @escaping (Result<Void, Error>) -> Void)
	func removeUser(id: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class FirestoreUsersDataService {
	private let database = Firestore.firestore()
}

// MARK: - FirestoreUsersDataServiceProtocol
extension FirestoreUsersDataService: FirestoreUsersDataServiceProtocol {
	func isUserExists(email: String, completion: @escaping ((Bool) -> Void)) {
		database.collection("users").whereField("email", isEqualTo: email).getDocuments { (snapshot, error) in
			guard let documents = snapshot?.documents, documents.count != 0, error == nil else {
				completion(false)
				return
			}
			completion(true)
		}
	}

	func addUser(id: String, email: String, completion: @escaping (Result<Void, Error>) -> Void) {
		database.collection("users").document(id).setData(["email": email]) { error in
			if error == nil {
				completion(.success(Void()))
			} else {
				completion(.failure(Errors.AuthError.failedToContinue))
			}
		}
	}

	func removeUser(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
		database.collection("users").document(id).delete { error in
			if error == nil {
				completion(.success(Void()))
			} else {
				completion(.failure(Errors.AuthError.failedToLogOut))
			}
		}
	}
}
