//
//  FirebaseDemoView.swift
//  maobi
//
//  Created by Dora Xiao on 10/25/23.
//

import SwiftUI




struct FirebaseDemoView: View {
  
  @ObservedObject var userRepository = UserRepository()
  
  var body: some View {
    
    let users = userRepository.allUsers
    let levels = userRepository.allLevels
    let feedbacks = userRepository.allFeedback
    
    VStack {
      Text("Demo of Firebase")
      NavigationView {
        List {
          ForEach(users, id: \.self) { user in
            NavigationLink(
              destination: UserDetailsView(levels: userRepository.getLevelsForUser(user.userID, levels), userRepository: userRepository, feedbacks: feedbacks),
              label: {
                VStack(alignment: .leading) {
                  Text("Username: " + user.username)
                  Text("Password: " + user.password)
                  Text("Stars: " + String(user.totalStars))
                }
                }).padding()
              }
          }.navigationBarTitle("Users")
        }
      }
      
    }
    
  }


struct FirebaseDemoView_Previews: PreviewProvider {
  static var previews: some View {
    FirebaseDemoView()
  }
}
