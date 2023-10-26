import SwiftUI
import WebKit
import Foundation


// Demo of tutorial finger-writing tool

struct TutorialView: View {
  @State var text : String
   
  var body: some View {
    WebView(text: $text)
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
  }
}


