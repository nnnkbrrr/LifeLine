//
//  ContentView.swift
//  LifeLine
//
//  Created by Никита Баранов on 01.05.2023.
//

import SwiftUI

// MARK: --
// MARK: - Activity
/// dateSince: Int
/// dateTill: Int
/// 	stepsCount: Int?   				????????
/// 	distanceInMeters: Int 			????????
/// 	calories: Int?					????????
/// 	avgHeartbeat: Int? 				????????
/// 									visit, movement, workouts

// MARK: --
// MARK: - Visit
/// name
/// address
/// latitude
/// longitude
/// horizontalAccuracy

// MARK: --
// MARK: - Motion
/// activityType: String

// MARK: --
// MARK: - Workouts!!!!!

// MARK: --
// MARK: - Sleep data!!!!!!

struct ContentView: View {
	@ObservedObject var locationManager: LocationManager = .init()
	@ObservedObject var motionActivityManager: MotionActivityManager = .init()
	
	var body: some View {
		if locationManager.authorizationStatus == .authorizedAlways {
			Timeline()
		} else {
			OnboardingView(locationManager: locationManager, motionActivityManager: motionActivityManager)
		}
	}
}
