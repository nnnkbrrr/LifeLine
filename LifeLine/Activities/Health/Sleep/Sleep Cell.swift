//
//  Sleep Cell.swift
//  LifeLine
//
//  Created by Никита Баранов on 22.05.2023.
//

import SwiftUI

struct SleepCell: View {
	@Environment(\.managedObjectContext) private var moc
	@ObservedObject var sleep: Sleep
	
	var body: some View {
		VStack {
			VStack(alignment: .leading) {
				Text("**dateSince:** \(sleep.dateSince)")
				Text("**dateTill:** \(sleep.dateTill)")
			}
			.font(.callout)
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(10)
			.background(Color.blue.opacity(0.5))
			.cornerRadius(15)
			
			HStack {
				Button {
					moc.delete(sleep)
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
