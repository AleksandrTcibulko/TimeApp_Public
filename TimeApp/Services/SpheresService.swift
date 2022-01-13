//
//  SpheresService.swift
//  TimeApp
//
//  Created by Tsibulko on 04.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import UIKit

protocol SpheresServiceProtocol {
	func getSpheres() -> [Sphere]
}

final class SpheresService: SpheresServiceProtocol {
	func getSpheres() -> [Sphere] {
		[
			Sphere(title: "Базовые потребности", image: UIImage(named: "essential")),
			Sphere(title: "Карьера и Бизнес", image: UIImage(named: "busiwork")),
			Sphere(title: "Отдых и Развлечения", image: UIImage(named: "relax")),
			Sphere(title: "Любовь и Отношения", image: UIImage(named: "love")),
			Sphere(title: "Друзья и Родственники", image: UIImage(named: "friendrel")),
			Sphere(title: "Здоровье и Спорт", image: UIImage(named: "health")),
			Sphere(title: "Творчество и Духовность", image: UIImage(named: "creative")),
			Sphere(title: "Инвестиции и Финансы", image: UIImage(named: "investment")),
			Sphere(title: "Грабители времени", image: UIImage(named: "waste"))
		]
	}
}
