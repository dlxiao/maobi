//
//  TutorialSixView.swift
//  maobi
//
//  Created by Teresa Yuefan Yang on 11/3/23.
//

import SwiftUI

struct TutorialSixView: View {
    var levels: Levels
  var user : UserRepository
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
            ZStack{
                HomeView(levels: levels, user: user).disabled(true).navigationBarBackButtonHidden(false)
                VStack{
                    TopBarView(user: user)
                    Spacer()
                }


                ZStack{
                    Color.black.opacity(0.6).ignoresSafeArea()
                    VStack{
                        Text("You're all set.").font(.largeTitle).fontWeight(.bold).foregroundColor(.white).padding()
                        Text("Have fun!").font(.largeTitle).fontWeight(.bold).foregroundColor(.white).padding()
                    }
                }

              HStack {
                NavigationLink(
                    destination: TutorialFiveView(levels: levels, user: user),
                    label: {
                        Text("Back").foregroundColor(.white)
                    }).offset(x:-80, y:300)
//                  if !viewModel.menuView{
//                      NavigationLink(
//      //                    destination: !viewModel.menuView ? HomeView(levels: levels) : MenuView(levels: levels),
//                          destination: HomeView(levels: levels),
//                          label: {
//                              Text("Next").foregroundColor(.white)
//                          }).offset(x:80, y:300)
//
//                  }
//                  else if viewModel.menuView{
//                      NavigationLink(
//      //                    destination: !viewModel.menuView ? HomeView(levels: levels) : MenuView(levels: levels),
//                          destination: MenuView(levels: levels),
//                          label: {
//                              Text("Next").foregroundColor(.white)
//                          }).offset(x:80, y:300)
//
//                  }
                NavigationLink(
                    destination: !viewModel.menuView ? AnyView(HomeView(levels: levels, user: user)) : AnyView(MenuView(levels: levels, user: user)),
//                    destination: HomeView(levels: levels),
                    label: {
                        Text("Next").foregroundColor(.white)
                    }).offset(x:80, y:300)
                
                
              }
                
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .onDisappear{viewModel.isTabViewEnabled = true}

    }
}

//struct TutorialSixView_Previews: PreviewProvider {
//    static var previews: some View {
//        TutorialSixView()
//    }
//}
