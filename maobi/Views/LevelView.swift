//
//  LevelView.swift
//  maobi
//
//  Created by Dora Xiao on 10/31/23.
//

import SwiftUI

struct LevelView: View {
  var character : CharacterData
  var body: some View {
    VStack {
      Text(character.toString() + "  |  " + character.getPinyin()).font(.largeTitle).padding(20)
      Text("This character means \"" + character.getDefinition() + "\". To write it, follow the stroke order animation below:").padding(20)
      
      LevelGraphicsView(html: character.getLevelHTML()) // pass in image and animation
      Button(action: {}) {
        NavigationLink(
          destination: CameraView(),
          label: { Text("Check your Work!").fontWeight(.bold)
          })
      }.padding(.all)
        .background(Color(red: 0.83, green: 0.25, blue: 0.17))
        .foregroundColor(.white)
        .cornerRadius(15.0)
    }.padding([.bottom], 50)
    
    
  }
}
