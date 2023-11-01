import WebKit
import SwiftUI

struct HomeView: View {
  @ObservedObject var user = UserRepository()
  var levels = Levels()
  
  var body: some View {
    NavigationView {
      List {
        ForEach(levels.getBasicStrokes()) { c in // or levels.getCharacterLevels()
          NavigationLink(
            destination: LevelView(character: c),
            label: {Text(c.toString())} // Turn this into cards
          )
        }
      }
      
    }.navigationBarTitle("Levels")
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
