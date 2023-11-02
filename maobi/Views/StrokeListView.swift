//
//  StrokeListView.swift
//  maobi
//
//  Created by Teresa Yuefan Yang on 11/1/23.
//

import SwiftUI
import WebKit

struct StrokeListView: View {
//    var character : CharacterData
//    var level = Levels()
    var sampleStrokes = ["一", "丨", " ` ", "亅", "丶", "丿", "ノ"]
    var body: some View {
        NavigationView{
            ZStack {
                ScrollView{
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]){
                        
                        ForEach(sampleStrokes, id: \.self){
                            c in
                            VStack{
                                NavigationLink(destination: LevelView()){
                                    Text(c)
                                }
                                .frame(width: 162, height: 162)
                                .background(Color(red: 0.97, green: 0.94, blue: 0.91))
                                .cornerRadius(10)
                                .shadow(color: Color(red: 0.87, green: 0.78, blue: 0.7), radius: 0, x: 0, y: 4)
                                Text("stroke").bold()
                            }
                        }
                    }
                    
                }.padding(.top, 100)
                TopBarView()
            }
        }

    
        }
}

struct StrokeListView_Previews: PreviewProvider {
    static var previews: some View {
        StrokeListView()
    }
}
