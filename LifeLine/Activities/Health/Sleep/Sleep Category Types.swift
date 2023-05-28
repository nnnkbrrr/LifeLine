//
//  Sleep Category Types.swift
//  LifeLine
//
//  Created by Никита Баранов on 26.05.2023.
//

import HealthKit

extension HKCategoryValueSleepAnalysis {
	var string: String {
		switch self {
			case .asleep: return "Asleep"
			case .asleepCore: return "Asleep Core"
			case .asleepDeep: return "Asleep Deep"
			case .asleepREM: return "Asleep REM"
			case .asleepUnspecified: return "Asleep Unspecified"
			case .awake: return "Awake"
			case .inBed: return "In Bed"
			@unknown default: return "Unspecified"
		}
	}
}

extension String {
	var sleepCategoryType: HKCategoryValueSleepAnalysis {
		switch self {
			case "Asleep": return .asleepUnspecified
			case "Asleep Core": return .asleepCore
			case "Asleep Deep": return .asleepDeep
			case "Asleep REM": return .asleepREM
			case "Asleep Unspecified": return .asleepUnspecified
			case "Awake": return .awake
			case "In Bed": return .inBed
			default: return .asleepUnspecified
		}
	}
}
