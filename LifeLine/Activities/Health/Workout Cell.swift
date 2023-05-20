//
//  Workout Cell.swift
//  LifeLine
//
//  Created by Никита Баранов on 20.05.2023.
//

import SwiftUI

struct WorkoutCell: View {
	@Environment(\.managedObjectContext) private var moc
	@ObservedObject var workout: Workout
	
	var body: some View {
		VStack {
			VStack(alignment: .leading) {
				Text("**dateSince:** \(workout.dateSince)")
				Text("**dateTill:** \(workout.dateTill)")
				Text(workout.activityType)
			}
			.font(.callout)
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(10)
			.background(Color.orange.opacity(0.5))
			.cornerRadius(15)
			
			HStack {
				Button {
					moc.delete(workout)
					try? moc.save()
				} label: {
					Image(systemName: "trash")
						.foregroundColor(.red)
						.padding()
						.background(Color.gray.opacity(0.5))
						.clipShape(Circle())
				}
				.buttonStyle(.plain)
			}
		}
		.padding(.horizontal)
	}
}
