//
//  SortedCostCell.swift
//  TimeApp
//
//  Created by Tsibulko on 27.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

final class SortedCostCell: UITableViewCell {
	static let id = "SortedCostCell"

	private let shadowView = UIView(backgroundColor: .systemBackground, isShadow: true)
	private let containerView = UIView(backgroundColor: .clear, clipsToBounds: true)
	private let descriptionLabel = UILabel(text: "", numberOfLines: 0)
	private let graphView = UIView(backgroundColor: #colorLiteral(red: 0.7882352941, green: 0.9254901961, blue: 0.8980392157, alpha: 1), roundedCorners: false)
	private let timeLabel = UILabel(text: "", font: .verdana14(), numberOfLines: 0)
	private let percentLabel = UILabel(text: "", font: .verdana14(), numberOfLines: 0)

	var lenth: CGFloat = 0

	func configure(with sortedCost: SortedCost?) {
		guard let sortedCost = sortedCost else { return }
		descriptionLabel.text = sortedCost.cost.description
		timeLabel.text = sortedCost.cost.spendingInMinutes.convertToStringWithHoursAndMinutes()
		percentLabel.text = sortedCost.shareOfCostInsideSphere.convertToStringWithPercent()
		lenth = CGFloat(sortedCost.shareOfCostInsideSphere)
		setupLayout()
	}
}

// MARK: - Private
extension SortedCostCell {
	private func setupLayout() {
		contentView.clipsToBounds = true
		let stackView = UIStackView(arrangedSubviews: [descriptionLabel, graphView, timeLabel, percentLabel],
									axis: .vertical,
									distribution: .fill,
									alignment: .leading,
									spacing: 2)

		containerView.addSubview(stackView)
		shadowView.addSubview(containerView)
		contentView.addSubview(shadowView)

		NSLayoutConstraint.activate([
			shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
			shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
			shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
			shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

			containerView.topAnchor.constraint(equalTo: shadowView.topAnchor),
			containerView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
			containerView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
			containerView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),

			stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
			stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
			stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
			stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5),

			graphView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.3),
			graphView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: lenth),
		])
	}
}
