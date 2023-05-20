//
//  Workout.swift
//  LifeLine
//
//  Created by Никита Баранов on 20.05.2023.
//

import Foundation
import CoreData

@objc(Workout)
public class Workout: Activity {
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Workout> {
		return NSFetchRequest<Workout>(entityName: "Workout")
	}
	
	@NSManaged public var activityType: String
	@NSManaged public var healthKitSampleID: UUID
}
