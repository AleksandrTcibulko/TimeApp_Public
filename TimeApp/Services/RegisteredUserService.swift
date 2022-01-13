//
//  RegisteredUserService.swift
//  TimeApp
//
//  Created by Tsibulko on 09.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import Firebase
import FirebaseAuth

protocol RegisteredUserServiceProtocol {
	func register(with email: String, _ password: String, completion: @escaping ((Result<User, Error>) -> Void))
	func login(with email: String, _ password: String, completion: @escaping ((Result<String, Error>) -> Void))

	func sendResetPassword(to email: String, completion: @escaping (Result<Void, Error>) -> Void)

	func getUserId() -> String?
	func isUserExists(email: String, completion: @escaping ((Bool) -> Void))

	func logOut(completion: @escaping (Result<Void, Error>) -> Void)
	func remove(user: User)
}

final class RegisteredUserService {
	private let firestoreUsersDataService: FirestoreUsersDataServiceProtocol

	init(firestoreUsersDataService: FirestoreUsersDataServiceProtocol) {
		self.firestoreUsersDataService = firestoreUsersDataService
	}
}

// MARK: - RegisteredUserServiceProtocol
extension RegisteredUserService: RegisteredUserServiceProtocol {
	func register(with email: String, _ password: String, completion: @escaping ((Result<User, Error>) -> Void)) {
		FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
			guard let self = self, let user = authResult?.user, error == nil else {
				completion(.failure(Errors.AuthError.failedToRegisterWithEmail))
				return
			}
			self.firestoreUsersDataService.addUser(id: user.uid, email: email) { result in
				switch result {
				case .success():
					completion(.success(user))
				case .failure(let error):
					completion(.failure(error))
				}
			}
		}
	}

	func login(with email: String, _ password: String, completion: @escaping ((Result<String, Error>) -> Void)) {
		FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
			guard let authResult = authResult, error == nil else {
				completion(.failure(Errors.AuthError.failedToLoginWithEmail))
				return
			}
			completion(.success(authResult.user.uid))
		}
	}

	func sendResetPassword(to email: String, completion: @escaping (Result<Void, Error>) -> Void) {
		FirebaseAuth.Auth.auth().sendPasswordReset(withEmail: email) { error in
			completion(error == nil ? .success(Void()) : .failure(Errors.AuthError.failedToSendResetPasswordEmail))
		}
	}

	func getUserId() -> String? {
		FirebaseAuth.Auth.auth().currentUser?.uid
	}

	func isUserExists(email: String, completion: @escaping ((Bool) -> Void)) {
		firestoreUsersDataService.isUserExists(email: email) { userExists in
			if userExists {
				completion(true)
			} else {
				completion(false)
			}
		}
	}
	
	func logOut(completion: @escaping (Result<Void, Error>) -> Void) {
		do {
			try Auth.auth().signOut()
			completion(.success(Void()))
		}
		catch {
			completion(.failure(Errors.AuthError.failedToLogOut))
		}
	}

	func remove(user: User) {
		user.delete(completion: nil)
	}
}
