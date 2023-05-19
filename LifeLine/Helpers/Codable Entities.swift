//
//  Codable Entities.swift
//  LifeLine
//
//  Created by Никита Баранов on 06.05.2023.
//

import SwiftUI

extension Date: RawRepresentable {
	fileprivate static let formatter = ISO8601DateFormatter()
	
	public var rawValue: String {
		Date.formatter.string(from: self)
	}
	
	public init?(rawValue: String) {
		self = Date.formatter.date(from: rawValue) ?? Date()
	}
}
