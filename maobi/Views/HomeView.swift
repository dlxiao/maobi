import WebKit
import SwiftUI

struct HomeView: View {
  @EnvironmentObject var opData : OpData
  var body : some View {
    VStack {
      TopBarView(stars: opData.user!.totalStars)
      Spacer()
      
      HStack {
        VStack{
          Button(action: {
            opData.lastView = .home
            opData.currView = .strokelist
          }) {
            Image("strokes-icon").padding(10.0)
          }.buttonStyle(CustomButton())
          Text("Basic Strokes").bold()
        }
        
        VStack{
          Button(action: {
            opData.lastView = .home
            opData.currView = .characterlist
          }) {
            Image("character-icon").padding(10.0)
          }.buttonStyle(CustomButton())
          Text("Characters").bold()
        }
      }
      
      HStack {
        VStack{
          Button(action:{
            opData.lastView = .home
            // opData.currView = .extrapacks
          }){
            Image("stack").padding(10.0)
          }.buttonStyle(CustomButton())
          Text("Extra Packs").bold()
        }
        VStack{
          Button(action:{
            opData.lastView = .home
            // opData.currView = .dailychallenge
          }){
            Image("daily-icon").padding(10.0)
          }.buttonStyle(CustomButton())
          Text("Daily Challenge").bold()
        }
      }
      Spacer()
    }
  }
}
