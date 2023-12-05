//
//  StrokeListView.swift
//  maobi
//
//  Created by Teresa Yuefan Yang on 11/1/23.
//

import SwiftUI
import WebKit

#if !TESTING
struct CharacterListView: View {
  @EnvironmentObject var opData : OpData
  @State private var lockedPopup = false
  @State private var lockedCharacter = ""
  @State var text = ""
  var filteredLevels: [CharacterData]{
    if text.isEmpty{
      return opData.levels.getCharacterLevels()
    } else {
      return opData.levels.getCharacterLevels().filter{ c in
        c.getPinyin().folding(options: .diacriticInsensitive, locale: .current).localizedCaseInsensitiveContains(text) ||
        c.getDefinition().localizedCaseInsensitiveContains(text) ||
        c.toString().localizedCaseInsensitiveContains(text)
      }
    }
  }
  
  var body: some View {
    TopBarView(stars: opData.user!.totalStars)
    ZStack(alignment: .top) {
      VStack{
        // Back button
        VStack{
          HStack {
            Button(action: {
              opData.currView = opData.lastView.removeLast()
            }) {
              HStack {
                Image(systemName: "chevron.left")
                Text("Back")
              }.foregroundColor(.black).font(.title3).fontWeight(.bold)
            }.frame(maxWidth: .infinity, alignment: .leading)
          }.padding()
          
          //Search bar
          SearchBarView(text: $text).padding([.leading, .trailing])
        }
        
        // Levels tiles
        .alert("This level is locked. Pay 5 stars to unlock now?", isPresented: $lockedPopup) {
          Button("Unlock \(lockedCharacter) with Stars", role: .destructive) {
            // update unlocked array and refresh
            opData.user!.unlockLevel(lockedCharacter)
            opData.currView = .characterlist
          }
          Button("Cancel", role: .cancel) { }
        }
        ScrollView{
          LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]){
            ForEach(filteredLevels){ c in
              VStack{
                Button(action: {
                  // Only click into level if unlocked, otherwise give msg to pay
                  if let levelStars = opData.user!.unlocked[c.toString()] {
                    opData.character = c
                    opData.lastView.append(.characterlist)
                    opData.currView = .level
                  } else {
                    lockedCharacter = c.toString()
                    lockedPopup = true
                  }
                }) {
                  ZStack {
                    Text(c.toString())
                      .foregroundColor(Color.black)
                      .font(.system(.largeTitle))
                      .fontWeight(.bold)
                    
                    HStack(spacing: 0) {
                      if let levelStars = opData.user!.unlocked[c.toString()] {
                        if(levelStars == 0) {
                          Image("stargray").resizable().scaledToFit().saturation(2)
                          Image("stargray").resizable().scaledToFit().saturation(2)
                          Image("stargray").resizable().scaledToFit().saturation(2)
                        } else if (levelStars == 1) {
                          Image("star").resizable().scaledToFit().saturation(2)
                          Image("stargray").resizable().scaledToFit().saturation(2)
                          Image("stargray").resizable().scaledToFit().saturation(2)
                        } else if (levelStars == 2) {
                          Image("star").resizable().scaledToFit().saturation(2)
                          Image("star").resizable().scaledToFit().saturation(2)
                          Image("stargray").resizable().scaledToFit().saturation(2)
                        } else {
                          Image("star").resizable().scaledToFit().saturation(2)
                          Image("star").resizable().scaledToFit().saturation(2)
                          Image("star").resizable().scaledToFit().saturation(2)
                        }
                      } else {
                        Image(systemName: "lock.fill")
                          .foregroundColor(.black)
                      }
                    }.frame(maxWidth: screenWidth / 4, alignment: .trailing)
                      .offset(x: screenWidth / 20, y: screenWidth / 5 - screenWidth / 18 )
                  }
                }.frame(width: screenWidth / 2.5, height: screenWidth / 2.5)
                  .background(Color(red: 0.97, green: 0.94, blue: 0.91))
                  .cornerRadius(10)
                  .shadow(color: Color(red: 0.87, green: 0.78, blue: 0.7), radius: 0, x: 0, y: 4)
                  .onTapGesture { // increase tappable area
                    if let levelStars = opData.user!.unlocked[c.toString()] {
                      // navigate as usual
                      opData.character = c
                      opData.lastView.append(.characterlist)
                      opData.currView = .level
                    } else {
                      lockedCharacter = c.toString()
                      lockedPopup = true
                    }
                  }
                Text(c.getPinyin()).bold()
              }
            }
          }
          
        }.padding(.top)
      }
      
    }
  }
}
#endif
