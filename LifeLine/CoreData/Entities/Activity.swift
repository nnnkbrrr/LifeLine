//
//  Activity.swift
//  LifeLine
//
//  Created by Никита Баранов on 16.05.2023.
//

import Foundation
import CoreData

@objc(Activity)
public class Activity: NSManagedObject, Identifiable {
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
		return NSFetchRequest<Activity>(entityName: "Activity")
	}
	
	@NSManaged public var dateSince: Date
	@NSManaged public var dateTill: Date
}
