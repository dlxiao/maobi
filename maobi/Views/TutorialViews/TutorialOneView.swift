//
//  TutorialOneView.swift
//  maobi
//
//  Created by Teresa Yuefan Yang on 11/3/23.
//

import SwiftUI

struct TutorialOneView: View {
    var levels : Levels

    var body: some View {
        NavigationView{
            ZStack{
                HomeView(levels: levels).disabled(true)
                
                ZStack{
                    Color.black.opacity(0.6).ignoresSafeArea()
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
                
                NavigationLink(
                    destination: TutorialTwoView(levels: levels),
                    label: {
                        Text("Next")
                    })
                .offset(x: 150, y: 400)
                
            }
        }.navigationBarTitle("")
            .navigationBarHidden(true)
    }
}

//struct TutorialOneView_Previews: PreviewProvider {
//    static var previews: some View {
//        TutorialOneView()
//    }
//}
