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
    var viewModel = ViewModel()
    
  
  var levels = Levels()
  var body: some Scene {
    WindowGroup {
//      if showTutorial {
//        OnboardingView(levels: levels, onFinish: {
//          showTutorial = false
//          UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
//        })
//      } else {
//        HomeView(levels: levels)
//      }
//      TestNavView().environmentObject(viewModel)
        testStarView()
    }
    
  }
  
  
  
  static func isFirstLaunch() -> Bool {
    return !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
  }
  
}

// pop to root of navigation stack
// taken from https://stackoverflow.com/questions/57334455/how-can-i-pop-to-the-root-view-using-swiftui/59662275#59662275
struct NavigationUtil {
  static func popToRootView(animated: Bool = false) {
    findNavigationController(viewController: UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }?.rootViewController)?.popToRootViewController(animated: animated)
  }
  
  static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
    guard let viewController = viewController else {
      return nil
    }
    
    if let navigationController = viewController as? UITabBarController {
      return findNavigationController(viewController: navigationController.selectedViewController)
    }
    
    if let navigationController = viewController as? UINavigationController {
      return navigationController
    }
    
    for childViewController in viewController.children {
      return findNavigationController(viewController: childViewController)
    }
    
    return nil
  }
}
