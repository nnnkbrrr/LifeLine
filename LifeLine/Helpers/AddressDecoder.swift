//
//  AddressDecoder.swift
//  LifeLine
//
//  Created by Никита Баранов on 02.05.2023.
//

import SwiftUI
import CoreLocation
import Contacts

extension CLVisit {
	var address: String {
		get async {
			guard let address = try? await AddressDecoder.getAddress(for: self) else {
				return "Error"
			}
			return address
		}
	}
	
	var shortAddress: String {
		get async {
			guard let address = try? await AddressDecoder.getShortAddress(for: self) else {
				return "Error"
			}
			return address
		}
	}
}

extension CLLocation {
	var address: String {
		get async {
			guard let address = try? await AddressDecoder.getAddress(for: self) else {
				return "Error"
			}
			return address
		}
	}
	
	var shortAddress: String {
		get async {
			guard let address = try? await AddressDecoder.getShortAddress(for: self) else {
				return "Error"
			}
			return address
		}
	}
}

enum AddressDecoder {
	enum AddressError: Error {
		case noAddressFound
	}
	
	static func getAddress(for location: CLLocation) async throws -> String {
		let geocoder = CLGeocoder()
		let lines = try await geocoder.reverseGeocodeLocation(location)
		
		guard let mark = lines.first, let address = mark.postalAddress else {
			throw AddressError.noAddressFound
		}
		
		return CNPostalAddressFormatter.string(from: address, style: .mailingAddress)
	}
	
	static func getAddress(for visit: CLVisit) async throws -> String {
		guard let address = try? await self.getAddress(
			for: CLLocation(
				latitude: visit.coordinate.latitude,
				longitude: visit.coordinate.longitude
			)
		) else {
			throw AddressError.noAddressFound
		}
		
		return address
	}
	
	// Short Address
	
	static func getShortAddress(for location: CLLocation) async throws -> String {
		guard let fullAddress: String = try? await getAddress(for: location) else { throw AddressError.noAddressFound }
		if let shortAddress: String = fullAddress.components(separatedBy: CharacterSet.newlines).first {
			return shortAddress
		} else {
			throw AddressError.noAddressFound
		}
	}
	
	static func getShortAddress(for visit: CLVisit) async throws -> String {
		guard let shortAddress = try? await self.getShortAddress(
			for: CLLocation(
				latitude: visit.coordinate.latitude,
				longitude: visit.coordinate.longitude
			)
		) else {
			throw AddressError.noAddressFound
		}
		
		return shortAddress
	}
}
