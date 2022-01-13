//
//  Int+Extension.swift
//  TimeApp
//
//  Created by Tsibulko on 19.12.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

extension Int {
	func convertToStringWithHoursAndMinutes() -> String {
		if self % 60 != 0 {
			return "\(self / 60) ч \(self % 60) мин"
		} else {
			return "\(self / 60) ч"
		}
	}
}
