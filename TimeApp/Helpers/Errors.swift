//
//  Errors.swift
//  TimeApp
//
//  Created by Tsibulko on 06.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import Foundation

enum Errors: Error {

	enum AuthError {
		case notFilled
		case emailNotFilled
		case invalidEmail
		case invalidPassword
		case userAlreadyExists
		case failedToRegisterWithEmail
		case failedToCreateUserInFirebaseDatabase
		case failedToLoginWithEmail
		case unknownError
		case failedToLogOut
		case failedToContinue
		case failedToSendResetPasswordEmail
	}

	enum CostError {
		case timeNotFilled
		case descriptionNotFilled
		case unknownError
		case getCostsFailed
		case removingFailed
		case savingFailed
	}
}

extension Errors.AuthError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .notFilled:
			return NSLocalizedString("Пожалуйста, заполните все поля", comment: "")
		case .emailNotFilled:
			return NSLocalizedString("Пожалуйста, введите email", comment: "")
		case .invalidEmail:
			return NSLocalizedString("Формат почты не является допустимым", comment: "")
		case .invalidPassword:
			return NSLocalizedString("Пароль должен состоять из 6 и более символов", comment: "")
		case .userAlreadyExists:
			return NSLocalizedString("Пользователь с таким адресом электронной почты уже зарегистрирован", comment: "")
		case .failedToRegisterWithEmail:
			return NSLocalizedString("Не удается зарегистировать аккаунт", comment: "")
		case .failedToCreateUserInFirebaseDatabase:
			return NSLocalizedString("Не удается сохранить пользователя", comment: "")
		case .failedToLoginWithEmail:
			return NSLocalizedString("Не удается войти в систему. Проверьте, пожалуйста, введенный email и пароль.",
									 comment: "")
		case .unknownError:
			return NSLocalizedString("Неизвестная ошибка. Пожалуйста, обратитесь к разработчику!", comment: "")
		case .failedToLogOut:
			return NSLocalizedString(
				"Не удалось выйти из приложения. Пожалуйста, попробуйте еще раз или обратитесь к разработчику",
				comment: ""
			)
		case .failedToContinue:
			return NSLocalizedString(
				"Не удается продолжить. Пожалуйста, попробуйте еще раз или обратитесь к разработчику.",
				comment: ""
			)
		case .failedToSendResetPasswordEmail:
			return NSLocalizedString("Не удалось отправить письмо. Пожалуйста, проверьте введенный email.", comment: "")
		}
	}
}

extension Errors.CostError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .timeNotFilled:
			return NSLocalizedString("Введите, пожалуйста, количество часов и/или минут", comment: "")
		case .descriptionNotFilled:
			return NSLocalizedString("Напишите, пожалуйста, на что потратили время.", comment: "")
		case .unknownError:
			return NSLocalizedString("Неизвестная ошибка. Пожалуйста, обратитесь к разработчику!", comment: "")
		case .getCostsFailed:
			return NSLocalizedString("Не удалось загрузить данные. Пожалуйста, проверьте интернет-соединение.",
									 comment: "")
		case .removingFailed:
			return NSLocalizedString("Не удалось удалить запись. Пожалуйста, попробуйте еще раз.", comment: "")
		case .savingFailed:
			return NSLocalizedString("Не удалось сохранить запись. Пожалуйста, попробуйте еще раз.", comment: "")
		}
	}
}
