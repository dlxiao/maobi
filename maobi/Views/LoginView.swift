//
//  LoginView.swift
//  maobi
//
//  Created by Dora Xiao on 11/15/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift
import SwiftUI

#if !TESTING
struct LoginView: View {
  @EnvironmentObject var opData : OpData
  @State var formUsername : String = "sampleusername_1"
  @State var formPassword : String = "password_1"
  @State var validAccount = true
  
  // async completion handler for initalizing user
  func onLogin() async -> Void {
      var userRepo = UserRepository(formUsername, formPassword)
      userRepo.loginUser() { userResult in
        if let user = userResult {
          if(user.count != 1) {
            validAccount = false
            print("Couldn't fetch user")
          } else {
            self.opData.user = userRepo
            if(user[0].completedTutorial) {
              opData.currView = .home
            } else {
              opData.currView = .onboarding
            }
          }
        } else {
          validAccount = false
          print("Couldn't fetch user")
        }
      }
    }
  
  var body: some View {
    
    VStack {
      Spacer()
      Image("maobi_logo")
      
      VStack {
        TextField("username", text: $formUsername)
          .padding(.all)
          .background(Color.white)
          .frame(width: screenWidth / 1.5)
          .cornerRadius(10)
        TextField("password", text: $formPassword)
          .padding(.all)
          .background(Color.white)
          .frame(width: screenWidth / 1.5)
          .cornerRadius(10)
          .padding()
      }
      Button(action: {
        opData.currView = .createaccount
      }) {
        Text("New user? Create account")
          .foregroundColor(Color.black)
          .underline(true)
      }.padding()
      
      
      AsyncButton(
          "Login",
          action: onLogin
      ).padding(.all)
        .background(Color(red: 0.83, green: 0.25, blue: 0.17))
        .foregroundColor(.white)
        .cornerRadius(15.0)
      
      Text("Couldn't find account. Please try again.").foregroundColor(validAccount ? Color(red: 0.9, green: 0.71, blue: 0.54) : Color.black)
      
      Spacer()
    }.frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color(red: 0.9, green: 0.71, blue: 0.54))
    
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView()
  }
}
#endif
