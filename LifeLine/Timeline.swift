//
//  Timeline.swift
//  LifeLine
//
//  Created by Никита Баранов on 04.05.2023.
//

import SwiftUI
import CoreMotion

struct Timeline: View {
	@Environment(\.managedObjectContext) private var moc
	@FetchRequest(entity: Activity.entity(), sortDescriptors: [
		NSSortDescriptor(keyPath: \Activity.dateSince, ascending: true)
	]) var activities: FetchedResults<Activity>
	
	var body: some View {
		InvertedScrollView {
			VStack {
				ForEach(Array(activities), id: \.self) { activity in
					if let visit = activity as? Visit {
						VisitCellView(visit: visit)
					} else if let motion = activity as? Motion {
						MotionCellView(motion: motion)
					} else if let workout = activity as? Workout {
						WorkoutCell(workout: workout)
					}
				}
			}
		}
	}
}
