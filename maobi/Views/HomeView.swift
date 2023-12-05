import WebKit
import SwiftUI

#if !TESTING
struct HomeView: View {
  @EnvironmentObject var opData : OpData
  var body : some View {
    VStack {
      TopBarView(stars: opData.user!.totalStars)
      Spacer()
      
      HStack {
        VStack{
          Button(action: {
            opData.lastView.append(.home)
            opData.currView = .strokelist
          }) {
            Image("strokes-icon").padding(10.0)
          }.buttonStyle(CustomButton())
          Text("Basic Strokes").bold()
        }
        
        VStack{
          Button(action: {
            opData.lastView.append(.home)
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
            opData.lastView.append(.home)
            // opData.currView = .extrapacks
          }){
            ZStack {
              Image("stack").padding(10.0)
              HStack(spacing: 0) {
                Image(systemName: "lock.fill")
                    .foregroundColor(.black)
              }.frame(maxWidth: screenWidth / 4, alignment: .trailing)
                .offset(x: screenWidth / 20, y: screenWidth / 5 - screenWidth / 18 )
            }
            
          }.buttonStyle(CustomButton())
          Text("Extra Packs").bold()
        }
        VStack{
          Button(action:{
            opData.lastView.append(.home)
            opData.character = opData.levels.getCharacter(opData.user!.dailyChallengeCharacter)
            opData.currView = .dailychallenge
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
#endif




