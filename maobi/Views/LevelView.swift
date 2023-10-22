import SwiftUI
import WebKit
import Foundation

struct LevelView: View {
  @State var text = displayCharByAPI("轮", 300)
   
  var body: some View {
    WebView(text: $text)
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
  }
}


