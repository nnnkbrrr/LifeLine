//
//  Motion Cell.swift
//  LifeLine
//
//  Created by Никита Баранов on 19.05.2023.
//

import SwiftUI

struct MotionCellView: View {
	@Environment(\.managedObjectContext) private var moc
	@ObservedObject var motion: Motion
	
	var body: some View {
		VStack {
			VStack(alignment: .leading) {
				Text("**dateSince:** \(motion.dateSince)")
				Text("**dateTill:** \(motion.dateTill)")
				Text(motion.activityType)
			}
			.font(.callout)
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(10)
			.background(Color.cyan.opacity(0.5))
			.cornerRadius(15)
			
			HStack {
				Button {
					moc.delete(motion)
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
