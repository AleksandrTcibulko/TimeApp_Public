//
//  Cost.swift
//  TimeApp
//
//  Created by Tsibulko on 05.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Cost: Equatable {
	let userId: String
	let id: String
	let sphere: String
	let description: String
	let spendingInMinutes: Int
	let date: Date

	init(userId: String,
		 id: String,
		 sphere: String,
		 description: String,
		 spendingInMinutes: Int,
		 date: Date) {
		self.userId = userId
		self.id = id
		self.sphere = sphere
		self.description = description
		self.spendingInMinutes = spendingInMinutes
		self.date = date
	}

	init?(document: QueryDocumentSnapshot) {
		let data = document.data()
		guard
			let userId = data["userId"] as? String,
			let sphere = data["sphere"] as? String,
			let description = data["description"] as? String,
			let spendingInMinutes = data["spendingInMinutes"] as? Int,
			let date = data["date"] as? Timestamp
		else { return nil }

		self.userId = userId
		self.id = document.documentID
		self.sphere = sphere
		self.description = description
		self.spendingInMinutes = spendingInMinutes
		self.date = date.dateValue()
	}
}
