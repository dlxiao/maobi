//
//  MenuView.swift
//  maobi
//
//  Created by Teresa Yuefan Yang on 11/1/23.
//

import SwiftUI

struct MenuView: View {
    
    var levels: Levels
    var user : UserRepository
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                Text("Guest")
                    .padding(.top, 50)
              NavigationLink(destination: OnboardingView(levels: levels, user: user)){Text("Tutorial")}
                    .padding(.top)
                    .navigationBarTitle("")
                      .navigationBarBackButtonHidden(true)
                      .navigationBarHidden(true)
                Text("Sign Out")
                    .fontWeight(.bold)
                    .foregroundColor(Color.red)
                    .padding(.top)
                
                Spacer()
            }
          
            .padding()
            .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .leading)
//            .background(
//                Rectangle()
//                    .fill(Color.white)
//                    .shadow(color: .black.opacity(0.25), radius: 2, x: 4, y:0)
//            )
//            .edgesIgnoringSafeArea(.all)
            
        }
        .navigationBarTitle("")
          .navigationBarBackButtonHidden(true)
          .navigationBarHidden(true)
        
    }
}

//struct MenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuView()
//    }
//}
