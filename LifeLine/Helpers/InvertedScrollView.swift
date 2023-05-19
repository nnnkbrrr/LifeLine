//
//  InvertedScrollView.swift
//  LifeLine
//
//  Created by Никита Баранов on 02.05.2023.
//

import SwiftUI

private struct FlippedUpsideDown: ViewModifier {
	func body(content: Content) -> some View {
		content
			.rotationEffect(Angle.degrees(180))
			.scaleEffect(x: -1, y: 1, anchor: .center)
	}
}

struct InvertedScrollView<Content: View>: View {
	@ViewBuilder var content: () -> Content
	
	init(@ViewBuilder content: @escaping () -> Content) {
		self.content = content
	}
	
	var body: some View {
		ScrollView {
			content()
				.modifier(FlippedUpsideDown())
		}
		.modifier(FlippedUpsideDown())
	}
}
