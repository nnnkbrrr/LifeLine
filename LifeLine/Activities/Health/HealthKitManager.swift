//
//  HealthKitManager.swift
//  LifeLine
//
//  Created by Никита Баранов on 20.05.2023.
//

import SwiftUI
import HealthKit
import CoreData

class HealthKitManager {
	let healthStore: HKHealthStore = .init()
	
	func authorizeHealthKit() {
		let readObjectTypes: Set<HKObjectType> = [
			HKSeriesType.workoutType(),
			HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
		]
		
		healthStore.requestAuthorization(toShare: .none, read: readObjectTypes) { (success, error) in
			if success {
				self.startObservingNewWorkouts()
//				self.startObservingNewSleepData()
			} else if let error {
				print("error authorizating HealthStore. You're propably on iPad \(error.localizedDescription)")
			}
		}
	}
	
	internal func get24hPredicate() -> NSPredicate {
		let today = Date()
		let startDate = Calendar.current.date(byAdding: .hour, value: -24, to: today)
		let predicate = HKQuery.predicateForSamples(withStart: startDate, end: today, options: [])
		return predicate
	}
}
