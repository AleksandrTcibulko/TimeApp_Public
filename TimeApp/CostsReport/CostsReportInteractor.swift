//
//  CostsReportInteractor.swift
//  TimeApp
//
//  Created by Tsibulko on 13.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import Foundation

protocol CostsReportInteractorProtocol {
	func getSortedCosts(completion: @escaping ([SortedCost]) -> Void)
	func remove(cost: Cost?, completion: @escaping (Result<Void, Error>) -> Void)
}

final class CostsReportInteractor {
	private let costService: CostServiceProtocol
	private var costs: [Cost]

	init(costService: CostServiceProtocol, costs: [Cost]) {
		self.costService = costService
		self.costs = costs
	}
}

// MARK: - CostsReportInteractorProtocol
extension CostsReportInteractor: CostsReportInteractorProtocol {
	func getSortedCosts(completion: @escaping ([SortedCost]) -> Void) {
		completion(sortByShareOfCostInsideSphere(costs))
	}

	func remove(cost: Cost?, completion: @escaping (Result<Void, Error>) -> Void) {
		guard let cost = cost else {
			completion(.failure(Errors.CostError.removingFailed))
			return
		}
		costService.remove(cost: cost) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success():
				guard let index = self.costs.firstIndex(of: cost) else {
					completion(.failure(Errors.CostError.removingFailed))
					return
				}
				self.costs.remove(at: index)
				completion(.success(Void()))
			case .failure(_):
				completion(.failure(Errors.CostError.removingFailed))
			}
		}
	}
}

// MARK: - Private
extension CostsReportInteractor {
	private func sortByShareOfCostInsideSphere(_ costs: [Cost]) -> [SortedCost] {
		let totalCosts = costs.map { $0.spendingInMinutes }.reduce(0, +)
		let sortedCosts = costs.map {
			SortedCost(cost: $0, shareOfCostInsideSphere: Double($0.spendingInMinutes) / Double(totalCosts))
		}.sorted(by: { $0.shareOfCostInsideSphere > $1.shareOfCostInsideSphere })
		return sortedCosts
	}
}
