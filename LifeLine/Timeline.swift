//
//  Timeline.swift
//  LifeLine
//
//  Created by Никита Баранов on 04.05.2023.
//

import SwiftUI
import CoreMotion
import Charts




import CoreData

struct Timeline: View {
	@Environment(\.managedObjectContext) private var moc
	@FetchRequest(entity: Activity.entity(), sortDescriptors: [
		NSSortDescriptor(keyPath: \Activity.dateSince, ascending: true)
	]) var activities: FetchedResults<Activity>
	
	var body: some View {
		TabView {
			if let minDate: Date = activities.map({ $0.dateSince }).min(),
			   let maxDate: Date = activities.map({ $0.dateTill }).max() {
				
				let timeDifferenceInHours: Int = Int(maxDate.timeIntervalSince(minDate))
				
				GeometryReader { geometry in
					ScrollView {
						Chart {
							ForEach(activities) { activity in
								BarMark(x: .value("Visit", 1), y: .value("", activity.dateSince..<activity.dateTill))
							}
						}
						.frame(height: CGFloat(timeDifferenceInHours) / 60 / 60 / 24 * geometry.size.height)
						.chartYAxis {
							AxisMarks(preset: .extended, position: .leading, values: .stride(by: .hour)) { value in
								AxisValueLabel(format: .dateTime)
							}
						}
					}
				}
				.tabItem { Label("Life", systemImage: "chart.bar") }
			}
			
			ScrollView {
				VStack {
					ForEach(Array(activities), id: \.self) { activity in
						if let visit = activity as? Visit {
							VisitCellView(visit: visit)
						} else if let motion = activity as? Motion {
							MotionCellView(motion: motion)
						} else if let workout = activity as? Workout {
							WorkoutCell(workout: workout)
						} else if let sleep = activity as? Sleep {
							SleepCell(sleep: sleep)
						}
					}
				}
			}
			.tabItem { Label("Life list", systemImage: "star") }
			
			List {
				Section {
					Button("Start observing sleep") {
						HealthKitManager().startObservingNewSleepData()
					}
					
					Button("Delete sleep data", role: .destructive) {
						let fetchRequest: NSFetchRequest<NSFetchRequestResult>  = NSFetchRequest(entityName: "Sleep")
						let deleteRequest: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
						_ = try? moc.execute(deleteRequest)
						
						try? moc.save()
					}
				}
				
				Section {
					Button("Start observing workouts") {
						HealthKitManager().startObservingNewWorkouts()
					}
					
					Button("Delete workouts data", role: .destructive) {
						let fetchRequest2: NSFetchRequest<NSFetchRequestResult>  = NSFetchRequest(entityName: "Workout")
						let deleteRequest2: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
						_ = try? moc.execute(deleteRequest2)
						
						try? moc.save()
					}
				}
			}
			.tabItem { Label("Tester", systemImage: "gear") }
		}
	}
}
