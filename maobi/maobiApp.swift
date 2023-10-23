import SwiftUI

@main
struct maobiApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
          CardView() // change back to ContentView after testing image thing
        }
    }
}
