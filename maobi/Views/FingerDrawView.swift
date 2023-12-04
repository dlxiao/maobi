
import SwiftUI
import WebKit
import Foundation

#if !TESTING
struct FingerDrawView: View {

  @State var html : String
   
  var body: some View {
    WebView(html: html)
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
  }
}
#endif

