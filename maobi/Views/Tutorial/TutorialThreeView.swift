//
//  TutorialThreeView.swift
//  maobi
//
//  Created by Teresa Yuefan Yang on 11/3/23.
//

import SwiftUI

struct TutorialThreeView: View {
    var levels: Levels
    
    var body: some View {
            ZStack{
                HomeView(levels: levels).disabled(true).navigationBarBackButtonHidden(false)

                ZStack{
                    Color.black.opacity(0.6).ignoresSafeArea()
                    Circle()
                        .frame(width: 200, height: 200)
                        .blendMode(.destinationOut)
                        .offset(x: -80, y: 140)
                    
                }
                .compositingGroup()
                Text("Learn and practice characters of a specific topic")
                    .foregroundColor(Color.white)
                    .frame(width: 200)
                    .offset(x: -80, y: 10)
                
                NavigationLink(
                    destination: TutorialFourView(levels: levels),
                    label: {
                        Text("Next")
                    })
                .offset(x: 150, y: 400)
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)

    }
}

//struct TutorialThreeView_Previews: PreviewProvider {
//    static var previews: some View {
//        TutorialThreeView()
//    }
//}
