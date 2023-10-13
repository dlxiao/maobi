//import SwiftUI
//
//private struct StrokeView: Shape {
//  private let path: UIBezierPath
//
//  init(path: UIBezierPath) {
//    self.path = path
//  }
//
//  func path(in rect: CGRect) -> Path {
//    let path = Path(path.cgPath)
//    return path.applying(
//        CGAffineTransform(
//          scaleX: rect.width / path.boundingRect.width / 1.5,
//            y: rect.height / path.boundingRect.height * -5
//        ).translatedBy(x: -500, y: 0)
//    )
//  }
//}
//
//struct CharView: View {
//  private var strokePaths: [UIBezierPath] {
//    return getCharacterBezierPaths("⺀")
////    return getCharacterBezierPaths("⺈")
////    return getCharacterBezierPaths("⺗")
//  }
//
//  var body: some View {
//    ZStack {
//      StrokeView(path: strokePaths[0]).fill(Color.black)
//      StrokeView(path: strokePaths[1]).fill(Color.black)
////      StrokeView(path: strokePaths[2]).fill(Color.black)
//    }
//  }
//}
//
//struct InspirationaTitle: View {
//  var body: some View {
//    ZStack {
//      Text("Hello World!")
//    }
//    .background(CharView())
//  }
//}
//



import SwiftUI
import WebKit
struct ContentView: View {
  @State var text = displayChar("⺗")
//  @State var text = displayChar("⺈")
   
  var body: some View {
    WebView(text: $text)
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
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
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
