//
//  StrokeListView.swift
//  maobi
//
//  Created by Teresa Yuefan Yang on 11/1/23.
//

import SwiftUI
import WebKit

#if !TESTING
struct PurchasesView: View {
  @EnvironmentObject var opData : OpData
  @State private var lockedPopup = false
  @State private var lockedPack = ""
  var buyStars = [("20 Stars", "$1.99", "star"), ("55 Stars", "$4.99", "55stars"), ("120 Stars", "$9.99", "120stars"), ("250 Stars", "$19.99", "250stars")]
  var buyBoosts = [("Watch Ad (1 per day)", "Earn 5 Stars", "ad"), ("Restore Streak", "$1.99", "streaks")]
  
  var body: some View {
    TopBarView(stars: opData.user!.totalStars)
    ZStack(alignment: .top) {
      VStack{
        // Back button
        VStack{
          HStack {
            Text("In-App Purchases").font(.title).fontWeight(.bold).foregroundColor(.black)
              .frame(width: screenWidth * 0.8, alignment: .leading)
            Button(action: {
              opData.currView = opData.lastView.removeLast()
            }) {
              HStack {
                Image(systemName: "xmark").font(.title).fontWeight(.bold)
              }.foregroundColor(.black).font(.title3).fontWeight(.bold)
            }.frame(maxWidth: .infinity, alignment: .trailing)
          }.padding()
          
        }
        
        // Levels tiles
        .alert("Coming soon...", isPresented: $lockedPopup) {
          Button("Ok", role: .cancel) { }
        }
        ScrollView{
          // Buy stars
          LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]){
            ForEach(buyStars+buyBoosts, id: \.self.0){ pack in
              VStack{
                Button(action: {
                  lockedPack = pack.0
                  lockedPopup = true
                }) {
                  VStack {
                    Image(pack.2)
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .scaleEffect(
                        (pack.2 == "star" || pack.2 == "55stars" || pack.2 == "streaks") ? 0.7 : 1.0
                      ).padding(.top)
                    Text(pack.1).foregroundColor(Color(red: 0.09, green: 0.502, blue: 0.055)).padding(.bottom)
                  }
                  
                }.frame(width: screenWidth / 2.5, height: screenWidth / 2.5)
                  .background(Color(red: 0.97, green: 0.94, blue: 0.91))
                  .cornerRadius(10)
                  .shadow(color: Color(red: 0.87, green: 0.78, blue: 0.7), radius: 0, x: 0, y: 4)
                  .onTapGesture { // increase tappable area
                    lockedPack = pack.0
                    lockedPopup = true
                  }
                Text(pack.0).bold()
              }
            }
          }
        }
      }
    }
  }
}
#endif
