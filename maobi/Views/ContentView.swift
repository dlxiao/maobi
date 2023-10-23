import SwiftUI
import WebKit

struct ContentView: View {
  var characterData = loadCharacterData()
  var basicStrokes = ["一", "丨", " ` ", "亅", "丶", "丿", "ノ"]
  var sampleCharacters = ["大", "小", "水", "天", "王", "十", "九", "八", "七", "六"]
  
  var body: some View {
    
    NavigationView {
      List {
        Section(header: Text("Strokes"), content: {
          ForEach(basicStrokes, id: \.self) { c in
            NavigationLink(
              destination: LevelView(text: displayLevel(c, characterData)),
              label: {Text(getLevelLabel(c, characterData))}
            )
          }
        })
        
        Section(header: Text("Characters"), content: {
          ForEach(sampleCharacters, id: \.self) { c in
            NavigationLink(
              destination: LevelView(text: displayLevel(c, characterData)),
              label: {Text(getLevelLabel(c, characterData))}
            )
          }
        })
        
      }
    }.navigationBarTitle("Demo of Character Data")
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
