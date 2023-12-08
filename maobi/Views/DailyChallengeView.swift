//
//  DailyChallengeView.swift
//  maobi
//
//  Created by Dora Xiao on 12/4/23.
//

import SwiftUI
#if !TESTING
struct DailyChallengeView: View {
  @EnvironmentObject var opData : OpData
  @StateObject var cameraModel = CameraModel()
  
  var body: some View {
    let character = opData.character!
    VStack {
      // Back button
      HStack {
        Button(action: { opData.currView = opData.lastView.removeLast() }) {
          HStack {
            Image(systemName: "chevron.left")
            Text("Back")
          }.foregroundColor(.black).font(.title3).fontWeight(.bold)
        }.frame(maxWidth: .infinity, alignment: .leading)
      }.padding()
      
      // Content
      Text(character.toString() + "  |  " + character.getPinyin()).font(.largeTitle).padding(20)
      Text("Daily Challenge: Complete this level today to unlock \(character.toString()) forever!").foregroundColor(.red).padding(20)
      Text("This character means \"" + character.getDefinition() + "\". To write it, follow the stroke order animation below:").padding(20)
      
      
      LevelGraphicsView(html: character.getLevelHTML()) // pass in image and animation
      Button(action: {
        opData.lastView.append(.dailychallenge)
        opData.currView = .camera
      }) {
        Text("Check your Work!").fontWeight(.bold)
      }.padding(.all)
        .background(Color(red: 0.83, green: 0.25, blue: 0.17))
        .foregroundColor(.white)
        .cornerRadius(15.0)
    }.padding([.bottom], 50)
  }
}

struct DailyChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        DailyChallengeView()
    }
}
#endif

