//
//  TutorialFourView.swift
//  maobi
//
//  Created by Teresa Yuefan Yang on 11/3/23.
//

import SwiftUI

struct TutorialFourView: View {
    var levels: Levels
    
    var body: some View {
            ZStack{
                HomeView(levels: levels).disabled(true).navigationBarBackButtonHidden(false)

                ZStack{
                    Color.black.opacity(0.6).ignoresSafeArea()
                    Circle()
                        .frame(width: 100, height: 100)
                        .blendMode(.destinationOut)
                        .offset(x: 170, y: -370)
                    
                }
                .compositingGroup()
                Text("Earn stars through practicing! Stars can unlock more characters")
                
                    .foregroundColor(Color.white)
                    .frame(width: 150)
                    .offset(x: 100, y: -270)
                
              HStack {
                NavigationLink(
                    destination: TutorialThreeView(levels: levels),
                    label: {
                        Text("Back").foregroundColor(.white)
                    }).offset(x:-80, y:-300)
                NavigationLink(
                    destination: TutorialFiveView(levels: levels),
                    label: {
                      Text("Next").foregroundColor(.white)
                    }).offset(x:80, y:-300)
                
                
              }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)

    }
}

//struct TutorialFourView_Previews: PreviewProvider {
//    static var previews: some View {
//        TutorialFourView()
//    }
//}
