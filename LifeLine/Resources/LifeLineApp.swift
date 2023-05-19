//
//  LifeLineApp.swift
//  LifeLine
//
//  Created by Никита Баранов on 16.04.2023.
//

import SwiftUI

@main
struct LifeLineApp: App {
	let persistenceController = PersistenceController.shared
	
    var body: some Scene {
        WindowGroup {
            ContentView()
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
