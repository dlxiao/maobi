import WebKit
import SwiftUI

struct HomeView: View {
  @EnvironmentObject var opData : OpData
  var body : some View {
    VStack {
      TutorialTopBarView(stars: opData.user!.totalStars)
      Spacer()
      
      HStack {
        VStack{
          Button(action: {opData.currView = .strokelist}) {
            Image("strokes-icon").padding(10.0)
          }.buttonStyle(CustomButton())
          Text("Basic Strokes").bold()
        }
        
        VStack{
          Button(action: {opData.currView = .characterlist}) {
            Image("character-icon").padding(10.0)
          }.buttonStyle(CustomButton())
          Text("Characters").bold()
        }
      }
      
      HStack {
        VStack{
          Button(action:{}){
            Image("stack").padding(10.0)
          }.buttonStyle(CustomButton())
          Text("Extra Packs").bold()
        }
        VStack{
          Button(action:{}){
            Image("daily-icon").padding(10.0)
          }.buttonStyle(CustomButton())
          Text("Daily Challenge").bold()
        }
      }
      Spacer()
    }
  }
}
