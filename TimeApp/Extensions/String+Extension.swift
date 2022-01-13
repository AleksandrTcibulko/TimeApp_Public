//
//  String+Extension.swift
//  TimeApp
//
//  Created by Tsibulko on 13.11.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

import Foundation

extension String {
	func convertToDate() -> Date? {
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "ru_RU")
		formatter.dateStyle = .long
		formatter.timeStyle = .none
		return formatter.date(from: self)
	}
}
