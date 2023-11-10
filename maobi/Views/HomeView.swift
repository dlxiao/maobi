import WebKit
import SwiftUI

struct HomeView: View {
  @ObservedObject var user = UserRepository()
    @EnvironmentObject var viewModel: ViewModel
  var levels : Levels
    
  var body: some View {
    NavigationView {
      ZStack{
        VStack{
          HStack{
            VStack{
              NavigationLink(destination: StrokeListView(levels: levels)){
                Image("strokes-icon")
                  .padding(10.0)
                
              }
              .frame(width: 162, height: 162)
              .background(Color(red: 0.97, green: 0.94, blue: 0.91))
              .cornerRadius(10)
              .shadow(color: Color(red: 0.87, green: 0.78, blue: 0.7), radius: 0, x: 0, y: 4)
              Text("Basic Strokes").bold()
              
            }
            
            VStack{
              NavigationLink(destination: CharacterListView(levels: levels)){
                Image("character-icon")
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
                Image("stack")
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
                Image("daily-icon")
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
        
        
      }
        
    }.navigationBarTitle("")
      .navigationBarBackButtonHidden(true)
      .navigationBarHidden(true)
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
