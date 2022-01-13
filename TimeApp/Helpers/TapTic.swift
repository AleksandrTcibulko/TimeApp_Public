//
//  TapTic.swift
//  TimeApp
//
//  Created by Tsibulko on 30.09.2020.
//  Copyright © 2020 Tsibulko. All rights reserved.
//

import UIKit

final class TapTic {
	static func makeErrorVibro() {
		let generator = UINotificationFeedbackGenerator()
		generator.notificationOccurred(.error)
	}
}
