import WebKit
import SwiftUI

struct HomeView: View {
  @ObservedObject var user = UserRepository()
  var levels = Levels()
  
  var body: some View {
    // let test = user.getUserLevels("")
    // let test2 = user.getAllFeedback()
    // Text(user.getUserID())
    // Text(user.getUsername())
    // Text(user.getPassword())
    // Text(String(user.getTotalStars()))
    
    var html = levels.example()
    WebView(html: html).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}

struct WebView: UIViewRepresentable {
  var html: String
  
  func makeUIView(context: Context) -> WKWebView {
    return WKWebView()
  }
  
  func updateUIView(_ uiView: WKWebView, context: Context) {
    uiView.loadHTMLString(html, baseURL: nil)
  }
}
