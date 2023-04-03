//
//  GolfTrackV2App.swift
//  GolfTrackV2
//
//  Created by Stephen Piccone on 2023-03-28.
//

import SwiftUI

@main
struct GolfTrackV2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
