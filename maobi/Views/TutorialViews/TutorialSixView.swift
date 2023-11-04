//
//  TutorialSixView.swift
//  maobi
//
//  Created by Teresa Yuefan Yang on 11/3/23.
//

import SwiftUI

struct TutorialSixView: View {
    var levels: Levels
    
    var body: some View {
            ZStack{
                HomeView(levels: levels).disabled(true).navigationBarBackButtonHidden(false)

                ZStack{
                    Color.black.opacity(0.6).ignoresSafeArea()
                    VStack{
                        Text("You're all set.").font(.largeTitle).fontWeight(.bold).foregroundColor(.white).padding()
                        Text("Have fun!").font(.largeTitle).fontWeight(.bold).foregroundColor(.white).padding()
                    }
                }

              HStack {
                NavigationLink(
                    destination: TutorialFiveView(levels: levels),
                    label: {
                        Text("Back").foregroundColor(.white)
                    }).offset(x:-80, y:-300)
                NavigationLink(
                    destination: HomeView(levels: levels),
                    label: {
                        Text("Next").foregroundColor(.white)
                    }).offset(x:80, y:-300)
                
                
              }
                
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)

    }
}

//struct TutorialSixView_Previews: PreviewProvider {
//    static var previews: some View {
//        TutorialSixView()
//    }
//}
