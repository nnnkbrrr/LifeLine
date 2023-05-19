//
//  Movement.swift
//  LifeLine
//
//  Created by Никита Баранов on 16.05.2023.
//

import Foundation
import CoreData

@objc(Motion)
public class Motion: Activity {
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Motion> {
		return NSFetchRequest<Motion>(entityName: "Movement")
	}
	
	@NSManaged public var activityType: String
}
