//
//  SphereCell.swift
//  TimeApp
//
//  Created by Tsibulko on 04.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit
import SwiftUI

final class SphereCell: UICollectionViewCell {
	static let id = "SphereCell"

	private let shadowView = UIView(backgroundColor: .systemBackground, isShadow: true)
	private let containerView = UIView(backgroundColor: .clear, clipsToBounds: true)
	private let sphereImageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
	private let sphereTitleLabel = UILabel(text: "",
										   font: .verdana15(),
										   numberOfLines: 0,
										   textAlignment: .center)

	override init(frame: CGRect) {
		super.init(frame: frame)
		contentView.backgroundColor = .clear
		setupLayout()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configureCell(with sphere: Sphere) {
		sphereImageView.image = sphere.image
		sphereTitleLabel.text = sphere.title
	}
}

// MARK: - Private
extension SphereCell {
	private func setupLayout() {
		contentView.clipsToBounds = true
		let stackView = UIStackView(arrangedSubviews: [sphereImageView, sphereTitleLabel],
									axis: .vertical,
									distribution: .fill,
									alignment: .center,
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

			stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
			stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
			stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

			sphereImageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.7),
			sphereImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),

			sphereTitleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.8)
		])
	}
}
