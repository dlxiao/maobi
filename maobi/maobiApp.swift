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
  @State private var showTutorial = isFirstLaunch()
  
  var body: some Scene {
      WindowGroup {
          if showTutorial {
              OnboardingView(onFinish: {
                  showTutorial = false
                  UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
              })
          } else {
              HomeView()
          }
      }
  }
  
  static func isFirstLaunch() -> Bool {
      return !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
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
