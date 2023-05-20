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
		let healthStore = HKHealthStore()
		
#warning("sleep, mindfullness")
		let readObjectTypes: Set<HKObjectType> = [HKSeriesType.workoutType()]
		
		healthStore.requestAuthorization(toShare: .none, read: readObjectTypes) { (success, error) in
			if success {
				self.startObservingNewWorkouts()
			} else if let error {
				print("error authorizating HealthStore. You're propably on iPad \(error.localizedDescription)")
			}
		}
	}
}

// MARK: Workouts

extension HealthKitManager {
	func startObservingNewWorkouts() {
		let sampleType = HKObjectType.workoutType()
		
		// Enable background delivery for workouts
		self.healthStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate) { (success, error) in
			if let unwrappedError = error { print("could not enable background delivery: \(unwrappedError)") }
			if success { print("background delivery enabled") }
		}
		
		// Open observer query
		let query = HKObserverQuery(sampleType: sampleType, predicate: nil) { (query, completionHandler, error) in
			self.updateWorkouts() { completionHandler() }
		}
		
		healthStore.execute(query)
	}
	
	func updateWorkouts(completionHandler: @escaping () -> Void) {
		var anchor: HKQueryAnchor?
		let sampleType = HKObjectType.workoutType()
		
		let anchoredQuery = HKAnchoredObjectQuery(
			type: sampleType,
			predicate: nil,
			anchor: anchor,
			limit: HKObjectQueryNoLimit
		) { [unowned self] query, newSamples, deletedSamples, newAnchor, error in
			if let newSamples, let deletedSamples {
				self.handleNewWorkouts(newSamples: newSamples, deletedSamples: deletedSamples)
			}
			
			anchor = newAnchor
			completionHandler()
		}
		
		healthStore.execute(anchoredQuery)
	}
	
	func handleNewWorkouts(newSamples: [HKSample], deletedSamples: [HKDeletedObject]) {
		for newSample in newSamples {
			if let workout = newSample as? HKWorkout {
				Task {
					let context = PersistenceController.shared.container.newBackgroundContext()
					context.automaticallyMergesChangesFromParent = true
					
					await context.perform {
						let newWorkout = Workout(context: context)
						newWorkout.dateSince = workout.startDate
						newWorkout.dateTill = workout.endDate
						newWorkout.activityType = workout.workoutActivityType.name
						newWorkout.healthKitSampleID = workout.uuid
						try? context.save()
					}
				}
			}
		}
		
		for deletedSample in deletedSamples {
			Task {
				let context = PersistenceController.shared.container.newBackgroundContext()
				context.automaticallyMergesChangesFromParent = true
				
				let fetchRequest: NSFetchRequest<NSFetchRequestResult>  = NSFetchRequest(entityName: "Workout")
				fetchRequest.predicate = NSPredicate(format: "healthKitSampleID == %@", deletedSample.uuid as CVarArg)
				let deleteRequest: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
				
				try context.execute(deleteRequest)
				try? context.save()
				
			}
		}
	}
}

