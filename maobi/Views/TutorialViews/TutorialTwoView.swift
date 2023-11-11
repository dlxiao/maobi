//
//  TutorialTwoView.swift
//  maobi
//
//  Created by Teresa Yuefan Yang on 11/3/23.
//

import SwiftUI

struct TutorialTwoView: View {
    var levels : Levels

    var body: some View {
            ZStack{
              HomeView(levels: levels).disabled(true)
                ZStack{
                    Color.black.opacity(0.6).ignoresSafeArea()
                    Circle()
                        .frame(width: 200, height: 200)
                        .blendMode(.destinationOut)
                        .offset(x: 80, y: -110)
                    
                }
                .compositingGroup()
                Text("Learn stroke order and practice basic characters")
                    .foregroundColor(Color.white)
                    .frame(width: 200)
                    .offset(x: 80, y: -250)
                
              HStack {
                NavigationLink(
                    destination: TutorialOneView(levels: levels),
                    label: {
                        Text("Back").foregroundColor(.white)
                    }).offset(x:-80, y:300)
                NavigationLink(
                    destination: TutorialThreeView(levels: levels),
                    label: {
                      Text("Next").foregroundColor(.white)
                    }).offset(x:80, y:300)
                
                
              }
            }

    }
}

//struct TutorialTwoView_Previews: PreviewProvider {
//    static var previews: some View {
//        TutorialTwoView()
//    }
//}