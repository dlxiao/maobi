//
//  TutorialTopbarView.swift
//  maobi
//
//  Created by Dora Xiao on 11/14/23.
//

import SwiftUI

#if !TESTING
struct TopBarView: View {
  @EnvironmentObject var opData : OpData
  var stars : Int
  
  var body: some View {
    let screenHeight = UIScreen.main.bounds.height
    let topbarSize = screenHeight * 0.06
    
    
    ZStack(alignment: .top){
      HStack{
        Button(action: {
          if(opData.currView == .menu) { // close menu
            opData.currView = opData.lastView.removeLast()
          } else { // open menu
            opData.lastView.append(opData.currView)
            opData.currView = .menu
          }
        }) {
          Image(systemName: "line.3.horizontal")
            .foregroundColor(.white)
            .fontWeight(.bold)
            .font(.title)
        }
        Spacer()
          Image("star")
            .foregroundColor(Color(red:1, green: 0.97, blue: 0.78))
            .frame(width: topbarSize, height: topbarSize)
            .scaleEffect(0.5)
          Text("\(stars)").bold() // Pretend user has 0 stars during tutorial
      }.padding([.leading, .trailing])
      .frame(maxWidth: .infinity)
      .background(Color(red: 0.9, green: 0.71, blue: 0.54))
    }
  }
}
#endif
