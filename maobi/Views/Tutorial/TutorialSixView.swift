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

                NavigationLink(
                    destination: HomeView(levels: levels),
                    label: {
                        Text("Next")
                    })
                .offset(x: 150, y: 400)
            }

    }
}

//struct TutorialSixView_Previews: PreviewProvider {
//    static var previews: some View {
//        TutorialSixView()
//    }
//}
