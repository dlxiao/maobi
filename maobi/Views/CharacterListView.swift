//
//  StrokeListView.swift
//  maobi
//
//  Created by Teresa Yuefan Yang on 11/1/23.
//

import SwiftUI
import WebKit

struct CharacterListView: View {
  @EnvironmentObject var opData : OpData
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
            ScrollView{
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]){
                    ForEach(filteredLevels){ c in
                        VStack{
                            Button(action: {
                                opData.character = c
                                opData.lastView.append(.characterlist)
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
                
            }.padding(.top)
        }

    }
  }
    }
