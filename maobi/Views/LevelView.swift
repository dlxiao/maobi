import SwiftUI
import WebKit
import Foundation

struct LevelView: View {
  @State var text : String
   
  var body: some View {
    WebView(text: $text)
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
  }
}

