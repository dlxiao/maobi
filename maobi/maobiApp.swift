import SwiftUI

@main
struct maobiApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
          HomeView()
        }
    }
}
