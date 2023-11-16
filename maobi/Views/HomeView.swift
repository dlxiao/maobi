import WebKit
import SwiftUI

//struct HomeView: View {
//  @EnvironmentObject var opData : opData
//
//  var body: some View {
//
//    NavigationView {
//      ZStack{
//        VStack{
//          HStack{
//            VStack{
//              NavigationLink(destination: StrokeListView(levels: levels, user: user)){
//                Image("strokes-icon")
//                  .padding(10.0)
//
//              }
//              .frame(width: 162, height: 162)
//              .background(Color(red: 0.97, green: 0.94, blue: 0.91))
//              .cornerRadius(10)
//              .shadow(color: Color(red: 0.87, green: 0.78, blue: 0.7), radius: 0, x: 0, y: 4)
//              Text("Basic Strokes").bold()
//
//            }
//
//            VStack{
//              NavigationLink(destination: CharacterListView(levels: levels, user: user)){
//                Image("character-icon")
//                  .padding(10.0)
//
//              }
//              .frame(width: 162, height: 162)
//              .background(Color(red: 0.97, green: 0.94, blue: 0.91))
//              .cornerRadius(10)
//              .shadow(color: Color(red: 0.87, green: 0.78, blue: 0.7), radius: 0, x: 0, y: 4)
//              Text("Characters").bold()
//
//            }
//          }.padding(50)
//
//          HStack{
//            VStack{
//              Button(action:{}){
//                Image("stack")
//                  .padding(10.0)
//
//              }
//              .frame(width: 162, height: 162)
//              .background(Color(red: 0.97, green: 0.94, blue: 0.91))
//              .cornerRadius(10)
//              .shadow(color: Color(red: 0.87, green: 0.78, blue: 0.7), radius: 0, x: 0, y: 4)
//              Text("Extra Packs").bold()
//
//            }
//
//            VStack{
//              Button(action:{}){
//                Image("daily-icon")
//                  .padding(10.0)
//
//              }
//              .frame(width: 162, height: 162)
//              .background(Color(red: 0.97, green: 0.94, blue: 0.91))
//              .cornerRadius(10)
//              .shadow(color: Color(red: 0.87, green: 0.78, blue: 0.7), radius: 0, x: 0, y: 4)
//              Text("Daily Challenge").bold()
//
//            }
//
//          }
//        }
//
//
//      }
//
//    }.navigationBarTitle("")
//      .navigationBarBackButtonHidden(true)
//      .navigationBarHidden(true)
//  }
//
//}
//
//




struct HomeView: View {
  @EnvironmentObject var opData : OpData
  var body : some View {
    Text("Home")
    Button(action: {
      opData.currView = .login
    }) {
      Text("Login again")
    }
  }
}
