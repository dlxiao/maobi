////
////  StrokeListView.swift
////  maobi
////
////  Created by Teresa Yuefan Yang on 11/1/23.
////
//
//import SwiftUI
//import WebKit
//
//struct StrokeListView: View {
////    var character : CharacterData
//  var levels : Levels
//  var user : UserRepository
//
//    var body: some View {
//      let sampleStrokes = levels.getBasicStrokes()
//            ZStack {
//                ScrollView{
//                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]){
//                        ForEach(sampleStrokes){
//                            c in
//                            VStack{
//                              NavigationLink(destination: LevelView(character: c, levels: levels, user: user)){
//                                Text(c.toString())
//                                      .foregroundColor(Color.black)
//                                      .font(.system(.largeTitle))
//                                      .fontWeight(.bold)
//                                }
//                                .frame(width: 162, height: 162)
//                                .background(Color(red: 0.97, green: 0.94, blue: 0.91))
//                                .cornerRadius(10)
//                                .shadow(color: Color(red: 0.87, green: 0.78, blue: 0.7), radius: 0, x: 0, y: 4)
//                              Text(c.getPinyin()).bold()
//                            }
//                        }
//                    }
//
//                }.padding(.top, 100)
//            }
//
//
//
//        }
//}
