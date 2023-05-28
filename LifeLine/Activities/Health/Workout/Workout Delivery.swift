//
//  Workout Delivery.swift
//  LifeLine
//
//  Created by Никита Баранов on 22.05.2023.
//

import SwiftUI
import HealthKit
import CoreData

extension HealthKitManager {
	func startObservingNewWorkouts() {
		let sampleType = HKObjectType.workoutType()
		
		self.healthStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate) { (_, _) in	}
		
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
				addNewWorkouts(newSamples)
				deleteWorkouts(deletedSamples)
			}
			
			anchor = newAnchor
			completionHandler()
		}
		
		healthStore.execute(anchoredQuery)
	}
	
	func addNewWorkouts(_ newSamples: [HKSample]) {
		Task {
			let context = PersistenceController.shared.container.newBackgroundContext()
			context.automaticallyMergesChangesFromParent = true
			
			await context.perform {
				for newSample in newSamples {
					if let workout = newSample as? HKWorkout {
						let newWorkout = Workout(context: context)
						newWorkout.dateSince = workout.startDate
						newWorkout.dateTill = workout.endDate
						newWorkout.activityType = workout.workoutActivityType.name
						newWorkout.healthKitSampleID = workout.uuid
					}
				}
				
				try? context.save()
			}
		}
	}
	
	func deleteWorkouts(_ deletedSamples: [HKDeletedObject]) {
		Task {
			let context = PersistenceController.shared.container.newBackgroundContext()
			context.automaticallyMergesChangesFromParent = true
			
			for deletedSample in deletedSamples {
				let fetchRequest: NSFetchRequest<NSFetchRequestResult>  = NSFetchRequest(entityName: "Workout")
				fetchRequest.predicate = NSPredicate(format: "healthKitSampleID == %@", deletedSample.uuid as CVarArg)
				let deleteRequest: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
				
				try context.execute(deleteRequest)
			}
			
			try? context.save()
		}
	}
}
