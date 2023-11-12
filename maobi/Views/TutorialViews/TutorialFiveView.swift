//
//  TutorialFiveView.swift
//  maobi
//
//  Created by Teresa Yuefan Yang on 11/3/23.
//

import SwiftUI

struct TutorialFiveView: View {
    var levels: Levels
  var user : UserRepository
    
    var body: some View {
            ZStack{
                HomeView(levels: levels, user: user).disabled(true).navigationBarBackButtonHidden(false)

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

              HStack {
                NavigationLink(
                    destination: TutorialFourView(levels: levels, user: user),
                    label: {
                        Text("Back").foregroundColor(.white)
                    }).offset(x:-80, y:300)
                NavigationLink(
                    destination: TutorialSixView(levels: levels, user: user),
                    label: {
                      Text("Next").foregroundColor(.white)
                    }).offset(x:80, y:300)
                
                
              }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)

    }
}

//struct TutorialFiveView_Previews: PreviewProvider {
//    static var previews: some View {
//        TutorialFiveView()
//    }
//}
