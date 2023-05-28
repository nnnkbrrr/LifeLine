//
//  ContentView.swift
//  LifeLine
//
//  Created by Никита Баранов on 01.05.2023.
//

import SwiftUI

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
