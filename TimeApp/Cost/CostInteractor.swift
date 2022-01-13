//
//  CostInteractor.swift
//  TimeApp
//
//  Created by Tsibulko on 05.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol CostInteractorProtocol {
	func createCost(with description: String?,
							hours: String?,
							minutes: String?,
							completion: @escaping (Result<Void, Errors.CostError>) -> Void)

	func validateInput(at textField: RoundedTextField, in range: NSRange, with string: String) -> Bool
}

final class CostInteractor {
	private let costCreationInfo: CostCreationInfo
	private let costService: CostServiceProtocol

	init(costCreationInfo: CostCreationInfo, costService: CostServiceProtocol) {
		self.costCreationInfo = costCreationInfo
		self.costService = costService
	}
}

// MARK: - CostInteractorProtocol
extension CostInteractor: CostInteractorProtocol {
	func createCost(with description: String?,
							hours: String?,
							minutes: String?,
							completion: @escaping (Result<Void, Errors.CostError>) -> Void) {
		guard let description = description,
			  description != "Напишите, чем занимались"
		else {
			completion(.failure(.descriptionNotFilled))
			return
		}
		guard !(hours == nil && minutes == nil),
			  !(hours == "" && minutes == "")
		else {
			completion(.failure(.timeNotFilled))
			return
		}

		let spendingInMinutes = (hours.flatMap { Int($0).flatMap { $0 * 60 } } ?? 0) + (minutes.flatMap { Int($0) } ?? 0)

		let df = DateFormatter()
		df.dateFormat = "yyyy-MM-dd"
		
		let newCost = Cost(userId: costCreationInfo.userId,
						   id: UUID().uuidString,
						   sphere: costCreationInfo.sphere,
						   description: description,
						   spendingInMinutes: spendingInMinutes,
						   date: costCreationInfo.date)
		costService.save(cost: newCost) { result in
			switch result {
			case .success():
				completion(.success(Void()))
			case .failure(_):
				completion(.failure(.unknownError))
			}
		}
	}

	func validateInput(at textField: RoundedTextField, in range: NSRange, with string: String) -> Bool {
		if [".", ","].firstIndex(of: string) != nil {
			return false
		}
		switch textField.textFieldInputType {
		case .hours:
			guard
				let updateHoursText = getUpdatedText(textField: textField, range: range, string: string),
				updateHoursText.count <= 2,
				updateHoursText.lessThan24()
			else { return false }
			return true
		case .minutes:
			guard
				let updateMinutesText = getUpdatedText(textField: textField, range: range, string: string),
				updateMinutesText.count <= 2,
				updateMinutesText.lessThan60()
			else { return false }
			return true
		default: return false
		}
	}
}

// MARK: - Private
extension CostInteractor {
	private func getUpdatedText(textField: RoundedTextField, range: NSRange, string: String) -> String? {
		let currentText = textField.text ?? ""
		guard let stringRange = Range(range, in: currentText) else { return nil }
		return currentText.replacingCharacters(in: stringRange, with: string)
	}
}

private extension String {
	func lessThan24() -> Bool {
		guard let int = Int(self) else { return true }
		return int <= 24 ? true : false
	}

	func lessThan60() -> Bool {
		guard let int = Int(self) else { return true }
		return int <= 60 ? true : false
	}
}
