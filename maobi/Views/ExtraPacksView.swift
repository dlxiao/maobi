//
//  StrokeListView.swift
//  maobi
//
//  Created by Teresa Yuefan Yang on 11/1/23.
//

import SwiftUI
import WebKit

#if !TESTING
struct ExtraPacksView: View {
  @EnvironmentObject var opData : OpData
  @State private var lockedPopup = false
  @State private var lockedPack = ""
  @State var text = ""
  var packs = ["Weather", "Fruits", "Animals", "Locations", "Flowers", "Holidays"]
  var filteredPacks: [String]{
    if text.isEmpty{
      return packs
    } else {
      return packs.filter{ pack in
        pack.localizedCaseInsensitiveContains(text)
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
          SearchBarView(filterDescription: "Filter packs", text: $text).padding([.leading, .trailing])
        }
        
        // Levels tiles
        .alert("Coming soon...", isPresented: $lockedPopup) {
          Button("Ok", role: .cancel) { }
        }
        ScrollView{
          LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]){
            ForEach(filteredPacks, id: \.self){ pack in
              VStack{
                Button(action: {
                    lockedPack = pack
                    lockedPopup = true
                }) {
                  ZStack {
                    Image(pack.lowercased())
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .scaleEffect(0.5)
                    Image(systemName: "lock.fill")
                      .foregroundColor(.black)
                      .frame(maxWidth: screenWidth / 4, alignment: .trailing)
                      .offset(x: screenWidth / 20, y: screenWidth / 5 - screenWidth / 18 )
                  }
                  
                }.frame(width: screenWidth / 2.5, height: screenWidth / 2.5)
                  .background(Color(red: 0.97, green: 0.94, blue: 0.91))
                  .cornerRadius(10)
                  .shadow(color: Color(red: 0.87, green: 0.78, blue: 0.7), radius: 0, x: 0, y: 4)
                  .onTapGesture { // increase tappable area
                      lockedPack = pack
                      lockedPopup = true
                  }
                Text(pack).bold()
              }
            }
          }
          
        }.padding(.top)

      }

      
    }
  }
}
#endif
