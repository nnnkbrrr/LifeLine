//
//  MotionActivityManager.swift
//  LifeLine
//
//  Created by Никита Баранов on 04.05.2023.
//

import SwiftUI
import CoreMotion

class MotionActivityManager: ObservableObject {
	@Published var authorizationStatus: CMAuthorizationStatus = CMMotionActivityManager.authorizationStatus()
	private var motionActivityManager = CMMotionActivityManager()
	
	public func requestAuthorization() {
		motionActivityManager.queryActivityStarting(
			from: .now, to: .now,
			to: OperationQueue.main,
			withHandler: { (activities: [CMMotionActivity]?, error: Error?) -> () in
				self.authorizationStatus = CMMotionActivityManager.authorizationStatus()
				self.motionActivityManager.stopActivityUpdates()
			}
		)
	}
}
