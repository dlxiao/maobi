import SwiftUI
import WebKit

struct ContentView: View {
  @State var text = displayCharByAPI("轮", 300)
  var characterData = loadCharacterData()
  var basicStrokes = ["一", "丨", "丶"]
  
  
  var body: some View {
    NavigationView {
          List(basicStrokes, id: \.self) { c in
            NavigationLink(
              destination: LevelView(text: displayCharByAPI(c, 300)),
              label: {
                Text(getLevelLabel(c, characterData))
              })
          }.navigationBarTitle("Characters")
        }
  }
}




struct WebView: UIViewRepresentable {
  @Binding var text: String
  
  func makeUIView(context: Context) -> WKWebView {
    return WKWebView()
  }
  
  func updateUIView(_ uiView: WKWebView, context: Context) {
    uiView.loadHTMLString(text, baseURL: nil)
  }
}
