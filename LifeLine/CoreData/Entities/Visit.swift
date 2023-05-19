//
//  Visit.swift
//  LifeLine
//
//  Created by Никита Баранов on 22.04.2023.
//

import Foundation
import CoreData

@objc(Visit)
public class Visit: Activity {
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Visit> {
		return NSFetchRequest<Visit>(entityName: "Visit")
	}
	
	@NSManaged public var address: String?
	@NSManaged public var horizontalAccuracy: Double
	@NSManaged public var latitude: Double
	@NSManaged public var longitude: Double
	@NSManaged public var name: String?
	
}
