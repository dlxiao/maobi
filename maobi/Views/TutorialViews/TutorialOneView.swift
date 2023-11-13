//
//  TutorialOneView.swift
//  maobi
//
//  Created by Teresa Yuefan Yang on 11/3/23.
//

import SwiftUI

struct TutorialOneView: View {
    var levels : Levels
  var user : UserRepository
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        NavigationView{
            ZStack{
                HomeView(levels: levels, user: user).disabled(true)
                VStack{
                    TopBarView(user: user)
                    Spacer()
                }

                
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
                
              HStack {
                NavigationLink(
                    destination: TutorialTwoView(levels: levels, user: user),
                    label: {
                      Text("Next").foregroundColor(.white)
                    }).offset(x:80, y:300)
                
                
              }
                
            }.onAppear{
                viewModel.isTabViewEnabled = false
                // give 10 free stars to users
                user.setTotalStars(0)
            }
            
        }.navigationBarHidden(true)
    }
}

//struct TutorialOneView_Previews: PreviewProvider {
//    static var previews: some View {
//        TutorialOneView()
//    }
//}
