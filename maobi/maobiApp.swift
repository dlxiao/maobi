//
//  maobiApp.swift
//  maobi
//
//  Created by Dora Xiao on 10/13/23.
//

import SwiftUI

@main
struct maobiApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
