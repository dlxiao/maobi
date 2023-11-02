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
    var level = Levels()
    
    var body: some View {
    
        ZStack{
            VStack{
                Text("Basic Strokes")
                
                    .font(.headline)
                    .frame(alignment: .leading)
                
                Button(action:{}){
                    
                    Image(systemName: "swift")
                        .padding(10.0)
                    
                }
                .frame(width: 162, height: 162)
                .background(Color(red: 0.97, green: 0.94, blue: 0.91))
                .cornerRadius(10)
                .shadow(color: Color(red: 0.87, green: 0.78, blue: 0.7), radius: 0, x: 0, y: 4)
                Text("Basic Strokes").bold()

                
            }
        }    }
}

struct StrokeListView_Previews: PreviewProvider {
    static var previews: some View {
        StrokeListView()
    }
}
