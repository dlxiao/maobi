//
//  MenuView.swift
//  maobi
//
//  Created by Teresa Yuefan Yang on 11/1/23.
//

import SwiftUI

#if !TESTING
struct MenuView: View {
  @EnvironmentObject var opData : OpData
  
  var body: some View {
    VStack(alignment: .leading) {
      TopBarView(stars: opData.user!.totalStars)

      HStack{
        Text("Hello, \(opData.user!.username)!").font(.title3)
          .frame(width: screenWidth * 0.8, alignment: .leading)
        Button(action: { opData.currView = opData.lastView.removeLast() }) {
          Image(systemName: "xmark").font(.title).fontWeight(.bold)
        }.frame(alignment: .trailing)
      }.padding().foregroundColor(.black)
      
      
      Button(action: {
        opData.currView = .onboarding
      }) {
        Text("Tutorial").fontWeight(.bold)
      }.padding()
      
      Button(action: {
        opData.currView = .purchases
      }) {
        Text("Purchases").fontWeight(.bold)
      }.padding()
      
      Button(action: {
        opData.currView = .login
      }) {
        Text("Sign Out").fontWeight(.bold).foregroundColor(.red)
      }.padding()
      Spacer()
    }
  }
}
#endif
