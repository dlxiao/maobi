import WebKit
import SwiftUI

struct HomeView: View {
  @ObservedObject var user = UserRepository()
  var levels = Levels()
  
  var body: some View {
    // let test = user.getUserLevels("")
    // let test2 = user.getAllFeedback()
    // Text(user.getUserID())
    // Text(user.getUsername())
    // Text(user.getPassword())
    // Text(String(user.getTotalStars()))
    
//    var html = levels.example()
//    WebView(html: html).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
      
      NavigationView{
          ZStack{
              VStack{
                  
                  HStack{
                      VStack{
                          NavigationLink(destination: StrokeListView()){
                              
                              Image(systemName: "swift")
                                  .padding(10.0)
                              
                          }
                          .frame(width: 162, height: 162)
                          .background(Color(red: 0.97, green: 0.94, blue: 0.91))
                          .cornerRadius(10)
                          .shadow(color: Color(red: 0.87, green: 0.78, blue: 0.7), radius: 0, x: 0, y: 4)
                          Text("Basic Strokes").bold()
                          
                      }
                      
                      VStack{
                          NavigationLink(destination: CharacterListView()){
                              Image(systemName: "swift")
                                  .padding(10.0)
                              
                          }
                          .frame(width: 162, height: 162)
                          .background(Color(red: 0.97, green: 0.94, blue: 0.91))
                          .cornerRadius(10)
                          .shadow(color: Color(red: 0.87, green: 0.78, blue: 0.7), radius: 0, x: 0, y: 4)
                          Text("Characters").bold()
                          
                      }
                  }.padding(50)
                  
                  HStack{
                      VStack{
                          Button(action:{}){
                              Image(systemName: "swift")
                                  .padding(10.0)
                              
                          }
                          .frame(width: 162, height: 162)
                          .background(Color(red: 0.97, green: 0.94, blue: 0.91))
                          .cornerRadius(10)
                          .shadow(color: Color(red: 0.87, green: 0.78, blue: 0.7), radius: 0, x: 0, y: 4)
                          Text("Extra Packs").bold()
                          
                      }
                      
                      VStack{
                          Button(action:{}){
                              Image(systemName: "swift")
                                  .padding(10.0)
                              
                          }
                          .frame(width: 162, height: 162)
                          .background(Color(red: 0.97, green: 0.94, blue: 0.91))
                          .cornerRadius(10)
                          .shadow(color: Color(red: 0.87, green: 0.78, blue: 0.7), radius: 0, x: 0, y: 4)
                          Text("Daily Challenge").bold()
                          
                      }
                      
                  }
              }
              
              TopBarView()
          }
      }

    
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
