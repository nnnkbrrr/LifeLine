//
//  LocationManager.swift
//  LifeLine
//
//  Created by Никита Баранов on 02.05.2023.
//

import SwiftUI
import CoreLocation
import CoreMotion

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
	@Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
	private let locationManager = CLLocationManager()
	
	override init () {
		super.init()
		locationManager.delegate = self
		locationManager.activityType = .other
		locationManager.allowsBackgroundLocationUpdates = true
		locationManager.pausesLocationUpdatesAutomatically = true
		locationManager.startMonitoringVisits()
	}
	
	public func requestAuthorization() {
		self.locationManager.requestAlwaysAuthorization()
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		self.authorizationStatus = status
	}
	
	#warning("did pause location updates method!!!")
	
	func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
		Task {
			if visit.arrivalDate != Date.distantPast && visit.departureDate != Date.distantFuture {
				let context = PersistenceController.shared.container.newBackgroundContext()
				context.automaticallyMergesChangesFromParent = true
				
				let address = await visit.address
				await context.perform {
					let newVisit = Visit(context: context)
					newVisit.address = address
					newVisit.latitude = visit.coordinate.latitude
					newVisit.longitude = visit.coordinate.longitude
					newVisit.horizontalAccuracy = visit.horizontalAccuracy
					newVisit.dateSince = visit.arrivalDate
					newVisit.dateTill = visit.departureDate
					
					if let lastVisitDeparture: Date =
						UserDefaults.standard.object(forKey: "last-visit-departure") as? Date {
						CMMotionActivityManager().queryActivityStarting(
							from: lastVisitDeparture, to: visit.arrivalDate,
							to: OperationQueue.current!,
							withHandler: { (activities: [CMMotionActivity]?, error: Error?) -> () in
								if let activities {
									var lastActivityType: CMMotionActivityType? = nil
									for activity in activities {
										if let motionType = activity.motionType, motionType != lastActivityType
											&& CMMotionActivityType.allMovementTypes.contains(motionType) {
											let newMotion = Motion(context: context)
											newMotion.dateSince = lastVisitDeparture
											newMotion.dateTill = visit.arrivalDate
											newMotion.activityType = motionType.stringValue
											
											lastActivityType = motionType
										}
									}
								}
							}
						)
					}
					
					UserDefaults.standard.set(visit.departureDate, forKey: "last-visit-departure")
					try? context.save()
				}
			}
		}
	}
}
