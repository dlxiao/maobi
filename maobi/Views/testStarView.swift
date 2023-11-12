//
//  testStarView.swift
//  maobi
//
//  Created by Teresa Yuefan Yang on 11/12/23.
//

import SwiftUI

struct testStarView: View {
    @EnvironmentObject var viewModel: ViewModel
    @ObservedObject var user = UserRepository()

    var body: some View {
        VStack{
            Text("\(user.getTotalStars())")
            
            Button(action: {user.updateStars(inc:5)
                user.addTotalStars(5)}){
                Text("add stars")
            }
            
            Text("fuck")
        }
    }
}

//struct testStarView_Previews: PreviewProvider {
//    static var previews: some View {
//        testStarView()
//    }
//}
