//
//  StrokeListView.swift
//  maobi
//
//  Created by Teresa Yuefan Yang on 11/1/23.
//

import SwiftUI
import WebKit

#if !TESTING
struct StrokeListView: View {
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
        
        // Levels tiles
        ScrollView{
          LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]){
            ForEach(opData.levels.getBasicStrokes()){ c in
              VStack{
                Button(action: {
                  opData.character = c
                  opData.lastView.append(.strokelist)
                  opData.currView = .level
                }) {
                  Text(c.toString())
                    .foregroundColor(Color.black)
                    .font(.system(.largeTitle))
                    .fontWeight(.bold)
                  
                }.frame(width: screenWidth / 2.5, height: screenWidth / 2.5)
                  .background(Color(red: 0.97, green: 0.94, blue: 0.91))
                  .cornerRadius(10)
                  .shadow(color: Color(red: 0.87, green: 0.78, blue: 0.7), radius: 0, x: 0, y: 4)
                Text(c.getPinyin()).bold()
              }
            }
          }
        }
      }
    }
  }
}
#endif
