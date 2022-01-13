//
//  Double+Extension.swift
//  TimeApp
//
//  Created by Tsibulko on 19.12.2021.
//  Copyright © 2021 Tsibulko. All rights reserved.
//

extension Double {
	func convertToStringWithPercent() -> String {
		"\((self * 10000).rounded() / 100)%"
	}
}
