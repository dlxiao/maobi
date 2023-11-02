//
//  CharacterListView.swift
//  maobi
//
//  Created by Teresa Yuefan Yang on 11/1/23.
//

import SwiftUI

struct CharacterListView: View {
    
    var sampleCharacters = ["大", "小", "水", "天", "王", "十", "九", "八", "七", "六"]
    
    var body: some View {
        NavigationView{
            ZStack {
                ScrollView{
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]){
                        
                        ForEach(sampleCharacters, id: \.self){
                            c in
                            VStack{
                                NavigationLink(destination: LevelView()){
                                    Text(c)
                                }
                                .frame(width: 162, height: 162)
                                .background(Color(red: 0.97, green: 0.94, blue: 0.91))
                                .cornerRadius(10)
                                .shadow(color: Color(red: 0.87, green: 0.78, blue: 0.7), radius: 0, x: 0, y: 4)
                                Text("char").bold()
                            }
                        }
                    }
                    
                }.padding(.top, 100)
                TopBarView()
            }
        }
    }
}

struct CharacterListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView()
    }
}
