import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct maobiApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
          HomeView()
        }
    }
}





//import UIKit
//import FirebaseCore
//
//
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//  var window: UIWindow?
//
//  func application(_ application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions:
//      [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//    FirebaseApp.configure()
//
//    return true
//  }
//}
