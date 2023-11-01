import WebKit
import SwiftUI

struct HomeView: View {
  @ObservedObject var user = UserRepository()
  var levels : Levels
  var body: some View {
    
    NavigationView {
      VStack{
        
      
      Text("Placeholder top bar")
      List {
        ForEach(levels.getCharacterLevels()) { c in // or levels.getBasicStrokes()
          NavigationLink(
            destination: LevelView(character: c),
            label: {Text(c.toString())} // Turn this into cards
          )
        }
      }
      Text("Placeholder bottom bar")
      }
    }.navigationTitle(Text("My Detail View"))
      .navigationBarTitleDisplayMode(.inline)
      
    
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
