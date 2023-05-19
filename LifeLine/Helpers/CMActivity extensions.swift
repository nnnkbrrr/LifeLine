//
//  CMActivity extensions.swift
//  LifeLine
//
//  Created by Никита Баранов on 19.05.2023.
//

import CoreMotion

enum CMMotionActivityType: String {
	case stationary = "Stationary",
		 walking = "Walking",
		 running = "Running",
		 automotive = "Automotive",
		 cycling = "Cycling",
		 unknown = "Unknown"
}

extension CMMotionActivityType {
	var stringValue: String {
		return self.rawValue
	}
	
	func getFromString(_ string: String) -> Self? {
		return Self.allTypes.first(where: { $0.stringValue == string })
	}
}

extension CMMotionActivityType {
	static var allTypes: [Self] = [.stationary, .walking, .running, .automotive, .cycling, .unknown]
	static var allMovementTypes: [Self] = [.walking, .running, .automotive, .cycling]
}

extension CMMotionActivity {
	var motionType: CMMotionActivityType? {
		if self.automotive {
			return .automotive
		} else if self.walking {
			return .walking
		} else if self.running {
			return .running
		} else if self.automotive {
			return .automotive
		} else if self.cycling {
			return .cycling
		} else if self.stationary {
			return .stationary
		} else if self.unknown {
			return .unknown
		}
		return nil
	}
}
