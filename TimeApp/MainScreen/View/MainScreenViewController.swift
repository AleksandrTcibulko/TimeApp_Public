//
//  MainScreenViewController.swift
//  TimeApp
//
//  Created by Tsibulko on 27.10.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol MainScreenViewControllerProtocol: AnyObject {
	func update(with spheres: [Sphere], and currentDate: String)
	func updateTitle(with date: String)
	func animateCellTap(at indexPath: IndexPath)
}

final class MainScreenViewController: UIViewController {
	private let currentDateLabel = UILabel(text: "")
	private let headerView = MainScreenHeaderView()
	private var lifeSpheresCollectionView: UICollectionView?
	private let showSpheresStatsButton = UIButton(title: "Посмотреть мой день!",
												  target: self,
												  action: #selector(showDayBySpheresTapped))

	private var headerViewTopConstraint: NSLayoutConstraint?
	private let padding: CGFloat = 10

	var presenter: MainScreenPresenterProtocol?

	private var spheres: [Sphere] = []

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		presenter?.viewDidLoad()
		setupNavigationBar()
		setupLifeSpheresCollectionView()
		setupUI()
	}
}

// MARK: - Button Action
extension MainScreenViewController {
	@objc private func showDayBySpheresTapped() {
		presenter?.openDayBySpheresTapped()
	}

	@objc private func settingsButtonTapped() {
		presenter?.settingsButtonTapped()
	}

	@objc func calendarButtonTapped() {
		presenter?.currentDateButtonTapped()
	}
}

// MARK: - Private
extension MainScreenViewController {
	private func setupNavigationBar() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar"),
											style: .plain,
											target: self,
											action: #selector(calendarButtonTapped))
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
											 style: .plain,
											 target: self,
											 action: #selector(settingsButtonTapped))
		navigationItem.titleView = currentDateLabel
	}

	private func setupLifeSpheresCollectionView() {
		let layout = UICollectionViewFlowLayout()
		lifeSpheresCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		lifeSpheresCollectionView?.register(SphereCell.self, forCellWithReuseIdentifier: SphereCell.id)
		lifeSpheresCollectionView?.dataSource = self
		lifeSpheresCollectionView?.delegate = self
		lifeSpheresCollectionView?.backgroundColor = .clear
		lifeSpheresCollectionView?.showsVerticalScrollIndicator = false
		lifeSpheresCollectionView?.translatesAutoresizingMaskIntoConstraints = false
	}

	private func setupUI() {
		headerViewTopConstraint = headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
		guard
			let lifeSpheresCollectionView = lifeSpheresCollectionView,
			let headerViewTopConstraint = headerViewTopConstraint
		else { return }

		[headerView, lifeSpheresCollectionView, showSpheresStatsButton].forEach { view.addSubview($0) }

		NSLayoutConstraint.activate([
			headerViewTopConstraint,
			headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),

			lifeSpheresCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
			lifeSpheresCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			lifeSpheresCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			lifeSpheresCollectionView.bottomAnchor.constraint(equalTo: showSpheresStatsButton.topAnchor, constant: -5),

			showSpheresStatsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
			showSpheresStatsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			showSpheresStatsButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
			showSpheresStatsButton.heightAnchor.constraint(equalToConstant: 52)
		])
	}
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainScreenViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						sizeForItemAt indexPath: IndexPath) -> CGSize {
		let itemsPerRow: CGFloat = 2
		let paddingWidth = padding * (itemsPerRow + 1)
		let availableWidth = collectionView.frame.width - paddingWidth

		let itemWidth = availableWidth / itemsPerRow
		let itemHeight = itemWidth * 1.2
		return CGSize(width: itemWidth, height: itemHeight)
	}

	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						insetForSectionAt section: Int) -> UIEdgeInsets {
		UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
	}

	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		padding
	}

	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		padding
	}
}

// MARK: - UICollectionViewDataSource
extension MainScreenViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		spheres.count
	}

	func collectionView(_ collectionView: UICollectionView,
						cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SphereCell.id,
															for: indexPath) as? SphereCell
		else { return UICollectionViewCell() }

		cell.configureCell(with: spheres[indexPath.item])
		return cell
	}
}

// MARK: - UICollectionViewDelegate
extension MainScreenViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		presenter?.didTapped(sphere: spheres[indexPath.item], at: indexPath)
	}
}

extension MainScreenViewController {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let yAxisScroll = scrollView.contentOffset.y
		let headerHeight = headerView.frame.height
		let isSwipingDown = yAxisScroll <= 0
		let shouldHideHeader = yAxisScroll <= headerHeight

		UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3,
													   delay: 0,
													   options: [],
													   animations: { [weak self] in
			guard let self = self else { return }
			self.headerView.alpha = isSwipingDown ? 1.0 : 0.0
		})

		headerViewTopConstraint?.constant = isSwipingDown ? 0 : (shouldHideHeader ? -yAxisScroll : -headerHeight)
	}
}

// MARK: - MainScreenViewControllerProtocol
extension MainScreenViewController: MainScreenViewControllerProtocol {
	func update(with spheres: [Sphere], and currentDate: String) {
		currentDateLabel.text = currentDate
		self.spheres = spheres
		lifeSpheresCollectionView?.reloadData()
	}

	func updateTitle(with date: String) {
		currentDateLabel.text = date
	}

	func animateCellTap(at indexPath: IndexPath) {
		guard let cell = lifeSpheresCollectionView?.cellForItem(at: indexPath) as? SphereCell
		else { return }
		UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
			cell.alpha = 0.1
		} completion: { _ in
			UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
				cell.alpha = 1
			}
		}
	}
}
