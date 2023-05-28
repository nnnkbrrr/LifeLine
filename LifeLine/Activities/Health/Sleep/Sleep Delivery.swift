//
//  Sleep Delivery.swift
//  LifeLine
//
//  Created by Никита Баранов on 22.05.2023.
//

import SwiftUI
import HealthKit
import CoreData

extension HealthKitManager {
	func startObservingNewSleepData() {
		let sampleType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
		
		self.healthStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate) { (_, _) in	}
		
		let query = HKObserverQuery(sampleType: sampleType, predicate: nil) { (query, completionHandler, error) in
			self.updateSleepData() { completionHandler() }
		}
		
		healthStore.execute(query)
	}
	
	func updateSleepData(completionHandler: @escaping () -> Void) {
		var anchor: HKQueryAnchor?
		let sampleType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
		
		let anchoredQuery = HKAnchoredObjectQuery(
			type: sampleType,
			predicate: nil,
			anchor: anchor,
			limit: HKObjectQueryNoLimit
		) { [unowned self] query, newSamples, deletedSamples, newAnchor, error in
			if let newSamples, let deletedSamples {
				addNewSleepData(newSamples)
				deleteSleepData(deletedSamples)
			}

			anchor = newAnchor
			completionHandler()
		}
		
		healthStore.execute(anchoredQuery)
	}
	
	func addNewSleepData(_ newSamples: [HKSample]) {
		Task {
			let context = PersistenceController.shared.container.newBackgroundContext()
			context.automaticallyMergesChangesFromParent = true
			
			context.perform {
				for newSample in newSamples {
					if let sleepData = newSample as? HKCategorySample,
					   let sleepDataValue = HKCategoryValueSleepAnalysis(rawValue: sleepData.value),
					   HKCategoryValueSleepAnalysis.allAsleepValues.contains(sleepDataValue)
					{
						let newSleepData = Sleep(context: context)
						newSleepData.dateSince = sleepData.startDate
						newSleepData.dateTill = sleepData.endDate
						newSleepData.sleepState = sleepDataValue.string
						newSleepData.healthKitSampleID = sleepData.uuid
					}
				}
				
				try? context.save()
			}
		}
	}
	
	func deleteSleepData(_ deletedSamples: [HKDeletedObject]) {
		Task {
			let context = PersistenceController.shared.container.newBackgroundContext()
			context.automaticallyMergesChangesFromParent = true
			
			for deletedSample in deletedSamples {
				let fetchRequest: NSFetchRequest<NSFetchRequestResult>  = NSFetchRequest(entityName: "Sleep")
				fetchRequest.predicate = NSPredicate(format: "healthKitSampleID == %@", deletedSample.uuid as CVarArg)
				let deleteRequest: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
				
				try context.execute(deleteRequest)
			}
			
			try? context.save()
		}
	}
}
