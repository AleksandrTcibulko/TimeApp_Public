//
//  MainScreenHeaderView.swift
//  TimeApp
//
//  Created by Tsibulko on 27.12.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

final class MainScreenHeaderView: UIView {
	private let headerText = UILabel(
		text: "На какие сферы жизни Вы сегодня потратили время?",
		numberOfLines: 0,
		textAlignment: .center
	)

	override init(frame: CGRect) {
		super.init(frame: .zero)
		backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.9254901961, blue: 0.8980392157, alpha: 1)
		translatesAutoresizingMaskIntoConstraints = false
		setupLayout()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Private
extension MainScreenHeaderView {
	private func setupLayout() {
		addSubview(headerText)
		NSLayoutConstraint.activate([
			headerText.topAnchor.constraint(equalTo: topAnchor),
			headerText.bottomAnchor.constraint(equalTo: bottomAnchor),
			headerText.leadingAnchor.constraint(equalTo: leadingAnchor),
			headerText.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
	}
}
