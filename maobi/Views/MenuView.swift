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
            Text("i")
            Text("love")
            Text("nothing")
        }
        .padding()
//        .background(
//            Rectangle()
//                .fill(Color.white)
//                .shadow(color: .black.opacity(0.25), radius: 2, x: 4, y:0))

    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
