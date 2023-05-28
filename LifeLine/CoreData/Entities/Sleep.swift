//
//  Sleep.swift
//  LifeLine
//
//  Created by Никита Баранов on 22.05.2023.
//

import Foundation
import CoreData

@objc(Sleep)
public class Sleep: Activity {
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Sleep> {
		return NSFetchRequest<Sleep>(entityName: "Sleep")
	}
	
	@NSManaged public var sleepState: String
	@NSManaged public var healthKitSampleID: UUID
}
