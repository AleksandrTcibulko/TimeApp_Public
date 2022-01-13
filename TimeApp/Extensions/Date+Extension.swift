//
//  Date+Extension.swift
//  TimeApp
//
//  Created by Tsibulko on 13.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import Foundation

extension Date {
	func convertToString() -> String {
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "ru_RU")
		formatter.dateStyle = .long
		formatter.timeStyle = .none
		return formatter.string(from: self)
	}

	func removeTimeComponents() -> Date? {
		let calendar = Calendar.current
		let components = calendar.dateComponents([.year, .month, .day], from: self)
		return calendar.date(from: components)
	}
}
