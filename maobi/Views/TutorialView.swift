//
//  TestView.swift
//  maobi
//
//  Created by Dora Xiao on 11/12/23.
//

import SwiftUI

let screenHeight = UIScreen.main.bounds.height
let screenWidth = UIScreen.main.bounds.width

struct TutorialView: View {
  @State var tutorialNum = 1
  @EnvironmentObject var opData : OpData
  
  var body: some View {
    ZStack(alignment: .bottom) {
      TutorialBackgroundView()
      
      VStack {
        if(tutorialNum == 6) {
          TopBarView(stars: 10)
            .mask(
              Rectangle()
                .frame(width: screenWidth / 3)
                .cornerRadius(10)
            )
            .overlay(
              Text("You're all set!\nHere are 10 stars to get you started.")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .frame(maxWidth: screenWidth - 50, maxHeight: .infinity)
                .offset(y: screenHeight * 0.06)
                .multilineTextAlignment(.center),
              alignment: .top
            )
        } else {
          TopBarView(stars: 0)
            .mask(
              Rectangle()
                .frame(width: screenWidth / 3)
                .cornerRadius(10)
            )
            .overlay(
              Text("Earn stars by practicing!\nStars are used unlock more levels.")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .frame(maxWidth: screenWidth - 50, maxHeight: .infinity)
                .offset(y: screenHeight * 0.06)
                .multilineTextAlignment(.center),
              alignment: .top
            )
            .opacity(tutorialNum == 3 ? 1.0 : 0.0)
        }
        
        Spacer()
        
        HStack {
          VStack{
            ZStack {
              Button(action: {}) {
                Image("strokes-icon").padding(10.0)
              }.buttonStyle(CustomButton())
              VStack {
                Text("Learn and practice the basic strokes")
                  .foregroundColor(.white)
                  .fontWeight(.bold)
              }.frame(width: screenWidth / 2.5)
                .offset(y: screenWidth / 5 + 50)
            }.zIndex(2)
            Text("Basic Strokes").bold()
          }.opacity(tutorialNum == 1 ? 1.0 : 0.0)
          
          VStack{
            ZStack {
              Button(action: {}) {
                Image("character-icon").padding(10.0)
              }.buttonStyle(CustomButton())
              VStack {
                Text("Learn stroke order and practice basic characters")
                  .foregroundColor(.white)
                  .fontWeight(.bold)
              }.frame(width: screenWidth / 2.5)
                .offset(y: screenWidth / 5 + 50)
            }.zIndex(2)
            Text("Characters").bold()
          }.opacity(tutorialNum == 2 ? 1.0 : 0.0)
        }
        
        HStack {
          VStack {
            ZStack {
              Button(action: {}) {
                Image("stack").padding(10.0)
              }.buttonStyle(CustomButton())
              VStack {
                Text("Unlock characters of a specific topic to practice")
                  .foregroundColor(.white)
                  .fontWeight(.bold)
              }.frame(width: screenWidth / 2.5)
                .offset(y: screenWidth / 5 + 50)
            }.zIndex(2)
            Text("Extra Packs")
            
          }.opacity(tutorialNum == 4 ? 1.0 : 0.0)
          
          VStack{
            ZStack {
              Button(action: {}) {
                Image("daily-icon").padding(10.0)
              }.buttonStyle(CustomButton())
              VStack {
                Text("Unlock a character every day by doing a daily challenge!")
                  .foregroundColor(.white)
                  .fontWeight(.bold)
              }.frame(width: screenWidth / 2.5)
                .offset(y: screenWidth / 5 + 50)
            }.zIndex(2)
            Text("Daily Challenge").bold()
          }.opacity(tutorialNum == 5 ? 1.0 : 0.0)
        }
        Spacer()
      }
      HStack {
        Button(action: {
          tutorialNum -= 1
        }) {
          Text("Back")
            .foregroundStyle(.white)
            .font(.title)
            .fontWeight(.bold)
            .opacity(tutorialNum <= 1 ? 0.0 : 1.0)
        }.disabled(tutorialNum <= 1)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(30)
        
        
        
        
        if(tutorialNum < 6) {
          Button(action: {
            tutorialNum += 1
          }) {
            Text("Next")
              .foregroundStyle(.white)
              .font(.title)
              .fontWeight(.bold)
          }.frame(maxWidth: .infinity, alignment: .trailing)
            .padding(30)
        } else {
          Button(action: {
            opData.user!.completeTutorial()
            opData.currView = .home
          }) {
            Text("Finish")
              .foregroundStyle(.white)
              .font(.title)
              .fontWeight(.bold)
          }.frame(maxWidth: .infinity, alignment: .trailing)
            .padding(30)
        }
        
      }
    }
  }
}

// Modular & dynamic button style
struct CustomButton: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .frame(width: screenWidth / 2.5, height: screenWidth / 2.5)
      .background(Color(red: 0.97, green: 0.94, blue: 0.91))
      .cornerRadius(10)
      .shadow(color: Color(red: 0.87, green: 0.78, blue: 0.7), radius: 0, x: 0, y: 4)
  }
}


struct TutorialView_Previews: PreviewProvider {
  static var previews: some View {
    TutorialView()
  }
}
