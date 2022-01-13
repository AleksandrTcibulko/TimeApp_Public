//
//  CostsReportViewController.swift
//  TimeApp
//
//  Created by Tsibulko on 13.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol CostsReportViewControllerProtocol: AnyObject {
	func update(with sortedCosts: [SortedCost], date: String)
}

final class CostsReportViewController: UIViewController {
	private let titleLabel = UILabel(text: "", textAlignment: .center)
	private let sortedCostsTableView = UITableView(frame: .zero, style: .plain)

	var sortedCosts: [SortedCost]?

	var presenter: CostsReportPresenterProtocol?

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		presenter?.viewDidLoad()
		setupNavigationBar()
		setupTableView()
		setupUI()
	}

	// MARK: - Button Action
	@objc private func backButtonTapped() {
		presenter?.backButtonTapped()
	}
}

//MARK: - Private
extension CostsReportViewController {
	private func setupNavigationBar() {
		navigationItem.titleView = titleLabel
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
														   style: .plain,
														   target: self,
														   action: #selector(backButtonTapped))
	}

	private func setupTableView() {
		sortedCostsTableView.register(SortedCostCell.self, forCellReuseIdentifier: SortedCostCell.id)
		sortedCostsTableView.dataSource = self
		sortedCostsTableView.delegate = self
		sortedCostsTableView.backgroundColor = .clear
		sortedCostsTableView.separatorColor = .clear
		sortedCostsTableView.rowHeight = 150
		sortedCostsTableView.translatesAutoresizingMaskIntoConstraints = false
	}

	private func setupUI() {
		view.addSubview(sortedCostsTableView)
		NSLayoutConstraint.activate([
			sortedCostsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			sortedCostsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			sortedCostsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			sortedCostsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
		])
	}
}

//MARK: - UITableViewDataSource
extension CostsReportViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		sortedCosts?.count ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: SortedCostCell.id,
													   for: indexPath) as? SortedCostCell
		else { return UITableViewCell() }
		cell.configure(with: sortedCosts?[indexPath.row])
		cell.selectionStyle = .none
		return cell
	}
}

//MARK: - Swipe Actions
extension CostsReportViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView,
				   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		UISwipeActionsConfiguration(actions: [removeAction(at: indexPath)])
	}

	private func removeAction(at indexPath: IndexPath) -> UIContextualAction {
		let action = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, completion) in
			guard let self = self else { return }
			let costToRemove = self.sortedCosts?[indexPath.row].cost
			self.presenter?.swipedToRemove(cost: costToRemove)
			completion(true)
		}
		action.backgroundColor = .systemRed
		action.image = UIImage(systemName: "trash")
		return action
	}
}

// MARK: - CostsReportViewControllerProtocol
extension CostsReportViewController: CostsReportViewControllerProtocol{
	func update(with sortedCosts: [SortedCost], date: String) {
		self.titleLabel.text = date
		self.sortedCosts = sortedCosts
		self.sortedCostsTableView.reloadData()
	}
}
