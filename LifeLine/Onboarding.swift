//
//  Onboarding.swift
//  LifeLine
//
//  Created by Никита Баранов on 22.04.2023.
//

import SwiftUI

struct OnboardingView: View {
	@ObservedObject var locationManager: LocationManager
	@ObservedObject var motionActivityManager: MotionActivityManager
	
	var body: some View {
		VStack {
			Text("To track your activities your location is required. This data will be retained on your device and is not collected by me in any way.")
				.font(.title2.weight(.black))
				.padding(30)
				.multilineTextAlignment(.center)
			
			Button {
				if locationManager.authorizationStatus == .notDetermined {
					locationManager.requestAuthorization()
				} else {
					UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
				}
			} label: {
				Text("Allow")
					.bold()
					.padding(.horizontal)
					.padding()
					.background(Color.accentColor)
					.clipShape(Capsule())
			}
			.buttonStyle(.plain)
			
			Text("To track your activities this app also requires access to motion and health data. It's up to you to decide rather to store it or not.")
			
			Button {
				motionActivityManager.requestAuthorization()
			} label: {
				Text("Motion & Fitness")
					.bold()
					.padding(.horizontal)
					.padding()
					.background(Color.accentColor)
					.clipShape(Capsule())
			}
			.buttonStyle(.plain)
			
			Button {
				HealthKitManager().authorizeHealthKit()
			} label: {
				Text("Health data")
					.bold()
					.padding(.horizontal)
					.padding()
					.background(Color.accentColor)
					.clipShape(Capsule())
			}
			.buttonStyle(.plain)
			
		}
	}
}
