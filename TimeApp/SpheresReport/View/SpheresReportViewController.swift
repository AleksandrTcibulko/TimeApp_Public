//
//  SpheresReportViewController.swift
//  TimeApp
//
//  Created by Tsibulko on 04.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol SpheresReportViewControllerProtocol: AnyObject {
	func updateTitleView(with date: String)
	func update(with sortedSpheres: [SortedSphere], isEmpty: Bool)
	func startSpinnerAnimation()
	func stopSpinnerAnimation()
}

final class SpheresReportViewController: UIViewController {
	private let titleLabel = UILabel(text: "", textAlignment: .center)
	private let emptyLabel = UILabel(text: "Похоже, что Вы еще не добавили никаких затрат за сегодня",
									 numberOfLines: 0,
									 textAlignment: .center)
	private let sortedSpheresTableView = UITableView(frame: .zero, style: .plain)
	private let openAllCostsReportButton = UIButton(title: "Посмотреть все траты",
													target: self,
													action: #selector(openAllCostsReportTapped))
	private let spinner = UIActivityIndicatorView(style: .large, hidesWhenStopped: true)

	private var sortedSpheres: [SortedSphere] = []

	var presenter: SpheresReportPresenterProtocol?

	// MARK: - Lyfecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		emptyLabel.isHidden = true
		presenter?.viewDidLoad()
		setupNavigationBar()
		setupTableView()
		setupUI()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		presenter?.viewWillAppear()
	}
}

// MARK: - Button Actions
extension SpheresReportViewController {
	@objc private func openAllCostsReportTapped() {
		presenter?.openAllCostsReportTapped(for: sortedSpheres)
	}

	@objc private func backButtonTapped() {
		presenter?.backButtonTapped()
	}
}

//MARK: - Private
extension SpheresReportViewController {
	private func setupNavigationBar() {
		navigationItem.titleView = titleLabel
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
														   style: .plain,
														   target: self,
														   action: #selector(backButtonTapped))
	}

	private func setupTableView() {
		sortedSpheresTableView.register(SortedSphereCell.self, forCellReuseIdentifier: SortedSphereCell.id)
		sortedSpheresTableView.dataSource = self
		sortedSpheresTableView.delegate = self
		sortedSpheresTableView.backgroundColor = .clear
		sortedSpheresTableView.separatorColor = .clear
		sortedSpheresTableView.rowHeight = 150
		sortedSpheresTableView.translatesAutoresizingMaskIntoConstraints = false
	}

	private func setupUI() {
		[sortedSpheresTableView, openAllCostsReportButton, spinner, emptyLabel].forEach { view.addSubview($0) }

		NSLayoutConstraint.activate([
			sortedSpheresTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			sortedSpheresTableView.bottomAnchor.constraint(equalTo: openAllCostsReportButton.topAnchor, constant: -20),
			sortedSpheresTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			sortedSpheresTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

			openAllCostsReportButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
			openAllCostsReportButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			openAllCostsReportButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
			openAllCostsReportButton.heightAnchor.constraint(equalToConstant: 52),

			spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),

			emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			emptyLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
			emptyLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
		])
	}
}

// MARK: - UITableViewDataSource
extension SpheresReportViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		sortedSpheres.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: SortedSphereCell.id, for: indexPath) as? SortedSphereCell
		else { return UITableViewCell() }
		cell.configure(with: sortedSpheres[indexPath.row])
		cell.selectionStyle = .none
		return cell
	}
}

// MARK: - UITableViewDelegate
extension SpheresReportViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let sortedSphere = sortedSpheres[indexPath.row]
		presenter?.didTapped(sortedSphere: sortedSphere)
	}
}

// MARK: - SpheresReportViewControllerProtocol
extension SpheresReportViewController: SpheresReportViewControllerProtocol{
	func updateTitleView(with date: String) {
		self.titleLabel.text = date
	}

	func update(with sortedSpheres: [SortedSphere], isEmpty: Bool) {
		self.sortedSpheres = sortedSpheres
		self.sortedSpheresTableView.reloadData()
		if isEmpty {
			emptyLabel.isHidden = false
			openAllCostsReportButton.isHidden = true
		}
	}

	func startSpinnerAnimation() {
		spinner.startAnimating()
	}

	func stopSpinnerAnimation() {
		spinner.stopAnimating()
	}
}
