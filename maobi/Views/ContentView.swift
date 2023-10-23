import SwiftUI
import WebKit

struct ContentView: View {
  var characterData = loadCharacterData()
  var basicStrokes = ["一", "丨", " ` ", "亅", "丶", "丿", "ノ"]
  var sampleCharacters = [""]
  
  var body: some View {
    VStack {
      NavigationView {
        List(basicStrokes, id: \.self) { c in
          NavigationLink(
            destination: LevelView(text: displayLevel(c, characterData)),
            label: {
              Text(getLevelLabel(c, characterData))
            })
        }.navigationBarTitle("Basic Strokes")
      }
//      NavigationView {
//        List(sampleCharacters, id: \.self) { c in
//          NavigationLink(
//            destination: LevelView(text: displayLevel(c, characterData)),
//            label: {
//              Text(getLevelLabel(c, characterData))
//            })
//        }.navigationBarTitle("Sample Characters")
//      }
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
