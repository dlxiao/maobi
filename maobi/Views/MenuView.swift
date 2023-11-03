//
//  MenuView.swift
//  maobi
//
//  Created by Teresa Yuefan Yang on 11/1/23.
//

import SwiftUI

struct MenuView: View {
    var levels : Levels

    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                Text("teresa_y")
                    .padding(.top, 100)
                NavigationLink(destination: TutorialOneView(levels: levels)){
                    Text("Tutorial")
                }.padding(.top)
                
                Text("Sign Out")
                    .padding(.top)
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .leading)
            .background(Color(.white))
        }

    }
}

//struct MenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuView(levels)
//    }
//}
