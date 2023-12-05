//
//  DailyChallengeView.swift
//  maobi
//
//  Created by Dora Xiao on 12/4/23.
//

import SwiftUI

struct DailyChallengeView: View {
  @EnvironmentObject var opData : OpData
  
  var body: some View {
    TopBarView(stars: opData.user!.totalStars)
    ZStack(alignment: .top) {
      VStack{
        // Back button
        HStack {
          Button(action: { opData.currView = opData.lastView.removeLast() }) {
            HStack {
              Image(systemName: "chevron.left")
              Text("Back")
            }.foregroundColor(.black).font(.title3).fontWeight(.bold)
          }.frame(maxWidth: .infinity, alignment: .leading)
        }.padding()
        VStack {
          Text("Daily Challenge Content")
        }
        Spacer()
      }
    }
  }
}

struct DailyChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        DailyChallengeView()
    }
}
