//
//  SpheresReportInteractor.swift
//  TimeApp
//
//  Created by Tsibulko on 13.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import Foundation

protocol SpheresReportInteractorProtocol {
	func getSortedSpheres(for userId: String,
						  at day: Date,
						  completion: @escaping (Result<[SortedSphere], Error>) -> Void)
}

final class SpheresReportInteractor {
	private let costService: CostServiceProtocol

	init(costService: CostServiceProtocol) {
		self.costService = costService
	}
}

// MARK: - SpheresReportInteractorProtocol
extension SpheresReportInteractor: SpheresReportInteractorProtocol {
	func getSortedSpheres(for userId: String,
						  at day: Date,
						  completion: @escaping (Result<[SortedSphere], Error>) -> Void) {
		costService.getCosts(day: day, userId: userId) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let costs):
				completion(.success(self.getSortedSpheres(from: costs)))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}

// MARK: - Private
extension SpheresReportInteractor {
	private func getSortedSpheres(from costs: [Cost]) -> [SortedSphere] {
		let spheresTitles = unique(costs.map { $0.sphere })
		let allSpendedTime = costs.map { $0.spendingInMinutes }.reduce(0, +)

		let sortedSpheres = spheresTitles.map { sphereTitle -> SortedSphere in
			let sortedSpendings = costs
				.filter { $0.sphere == sphereTitle }
				.sorted(by: { $0.spendingInMinutes > $1.spendingInMinutes })
			let timeSpendedForSphere = sortedSpendings.map { $0.spendingInMinutes }.reduce(0, +)
			return SortedSphere(title: sphereTitle,
								costs: sortedSpendings,
								timeSpendedForSphere: timeSpendedForSphere,
								shareOfSphereInAllSpendedTime: Double(timeSpendedForSphere) / Double(allSpendedTime))
		}.sorted(by: { $0.shareOfSphereInAllSpendedTime > $1.shareOfSphereInAllSpendedTime })

		return sortedSpheres
	}

	private func unique(_ array: [String]) -> [String] {
		return array.reduce(into: [], { (results, element) in
			if !results.contains(element) { results.append(element) }
		})
	}
}
