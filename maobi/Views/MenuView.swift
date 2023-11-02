//
//  MenuView.swift
//  maobi
//
//  Created by Teresa Yuefan Yang on 11/1/23.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        VStack(alignment: .leading){
            Text("teresa_y")
                .padding(.top, 150)
            Text("tyang218@gmail.com")
                .padding(.top)
            Text("Tutorial")
                .padding(.top)
            Text("Sign Out")
                .padding(.top)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .leading)
        .background(
            Rectangle()
                .fill(Color.white)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 4, y:0)
        )
        .edgesIgnoringSafeArea(.all)


    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
