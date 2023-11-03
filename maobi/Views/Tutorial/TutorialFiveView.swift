//
//  TutorialFiveView.swift
//  maobi
//
//  Created by Teresa Yuefan Yang on 11/3/23.
//

import SwiftUI

struct TutorialFiveView: View {
    var levels: Levels
    
    var body: some View {
            ZStack{
                HomeView(levels: levels).disabled(true)
                
                ZStack{
                    Color.black.opacity(0.6).ignoresSafeArea()
                    Circle()
                        .frame(width: 200, height: 200)
                        .blendMode(.destinationOut)
                        .offset(x: 80, y: 140)
                    
                }
                .compositingGroup()
                Text("Unlock a character every day by doing a daily challenge!")
                
                    .foregroundColor(Color.white)
                    .frame(width: 150)
                    .offset(x: 80, y: 0)

                NavigationLink(
                    destination: TutorialSixView(levels: levels),
                    label: {
                        Text("Next")
                    })
                .offset(x: 150, y: 400)
            }

    }
}

//struct TutorialFiveView_Previews: PreviewProvider {
//    static var previews: some View {
//        TutorialFiveView()
//    }
//}
