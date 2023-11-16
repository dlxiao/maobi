//
//  TutorialBackgroundView.swift
//  maobi
//
//  Created by Dora Xiao on 11/12/23.
//  Fake home page with disabled buttons for the tutorial

import SwiftUI

struct TutorialBackgroundView: View {
  var body: some View {
    
    VStack {
      TutorialTopBarView(stars: 0)
      Spacer()
      
      HStack {
        VStack{
          Button(action: {}) {
            Image("strokes-icon").padding(10.0)
          }.buttonStyle(CustomButton())
          Text("Basic Strokes").bold()
        }
        
        VStack{
          Button(action: {}) {
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
    }.overlay() { // start of overlay logic
      Color.black.opacity(0.6).ignoresSafeArea()
    }
  }
}


struct TutorialBackgroundView_Previews: PreviewProvider {
  static var previews: some View {
    TutorialBackgroundView()
  }
}
