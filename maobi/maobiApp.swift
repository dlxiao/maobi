import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit
import FirebaseCore
import WebKit


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

// Navigation & app data instead of passing variables to views
// https://www.hackingwithswift.com/forums/swiftui/pushing-a-view-without-navigation-view-swift-ui/6859
enum CurrView:Int {
  case onboarding
  case tutorial
  case home
  case login
  case strokelist
  case characterlist
  case level
  case menu
  case createaccount
  case camera
  case alignment
  case feedback
  case dailychallenge
  case levelquiz
  case extrapacks
  case purchases
}

// Environment variable for whole app
class OpData : ObservableObject {
  @Published var currView = CurrView.login
  @Published var levels = Levels()
  @Published var user : UserRepository? = nil
  @Published var character : CharacterData? = nil
  @Published var lastView : [CurrView] = [] // custom navigation stack
  @Published var cameraModel: CameraModel = CameraModel()
}

#if !TESTING
// For displaying animations and pictures of characters, UI Extension
struct WebView: UIViewRepresentable {
  var html: String
  
  func makeUIView(context: Context) -> WKWebView {
    return WKWebView()
  }
  func updateUIView(_ uiView: WKWebView, context: Context) {
    uiView.loadHTMLString(html, baseURL: nil)
  }
}
#endif


@main
struct maobiApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  private var opData = OpData()
  
  var body: some Scene {
    WindowGroup {
      NavigationView().environmentObject(opData)
    }
  }
}
