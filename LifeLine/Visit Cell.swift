//
//  Visit Cell.swift
//  LifeLine
//
//  Created by Никита Баранов on 19.05.2023.
//

import SwiftUI

struct VisitCellView: View {
	@Environment(\.managedObjectContext) private var moc
	@ObservedObject var visit: Visit
	
	var body: some View {
		VStack {
			VStack(alignment: .leading) {
				Text("**address:** \(visit.address ?? "")")
				Text("**Arrival:** \(visit.dateSince)")
				Text("**Departure:** \(visit.dateTill)")
			}
			.font(.callout)
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(10)
			.background(Color.gray.opacity(0.5))
			.cornerRadius(15)
			
			HStack {
				Button {
					moc.delete(visit)
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
