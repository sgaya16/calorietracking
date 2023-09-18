//
//  CalorieTrackingApp.swift
//  CalorieTracking
//
//  Created by Sara Gaya on 9/16/23.
//

import SwiftUI

@main
struct CalorieTrackingApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
