//
//  TutorialView.swift
//  maobi
//
//  Created by Teresa Yuefan Yang on 11/1/23.
//

import SwiftUI

struct TutorialView: View {
    @State private var step = 0
    var levels = Levels()
    
    var body: some View {
        ZStack{
            HomeView(levels: levels).disabled(true)
            
            ZStack{
                Color.black.opacity(0.5).ignoresSafeArea()
                Circle()
                    .frame(width: 200, height: 200)
                    .blendMode(.destinationOut)
                    .offset(x: -80, y: -110)
                
            }
            .compositingGroup()
            Text("Learn and practice the 8 basic strokes")
                .foregroundColor(Color.white)
                .frame(width: 200)
                .offset(x: -80, y: -250)
            
            Button(action: {
                if step < 2 {
                    step += 1
                }
            }){
                Text("Next").foregroundColor(.white)
            }
            Button(action: {
                if step >= 1 {
                    step -= 1
                }
            }){
                Text("Back").foregroundColor(.white)
            }


            
            
        }
        
        
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
