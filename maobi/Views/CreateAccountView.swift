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


struct CreateAccountView: View {
  @EnvironmentObject var opData : OpData
  @State var formEmail : String = "NewEmail"
  @State var formUsername : String = "NewUsername"
  @State var formPassword : String = "NewPassword"
  @State var formConfirmPassword : String = "NewPassword"
  @State var validAccount = true
  
  // async completion handler for creating account
  func onCreateAccount() async -> Void {
    var userRepo = UserRepository(formUsername, formPassword, formEmail)
    userRepo.createUser() { userResult in
      if let user = userResult {
        if(user.count != 1) {
          validAccount = false
          print("Couldn't fetch newly created user")
        } else {
          // always go to onboarding for new account
          self.opData.user = userRepo
          opData.currView = .onboarding
        }
      } else {
        validAccount = false
        print("Couldn't create user")
      }
    }
  }
  
  var body: some View {
    
    VStack {
      Spacer()
      Image("maobi_logo")
      
      VStack {
        TextField("Username", text: $formUsername)
          .padding(.all)
          .background(Color.white)
          .frame(width: screenWidth / 1.5)
          .cornerRadius(10)
        
        TextField("Email", text: $formEmail)
          .padding(.all)
          .background(Color.white)
          .frame(width: screenWidth / 1.5)
          .cornerRadius(10)
        
        TextField("Password", text: $formPassword)
          .padding(.all)
          .background(Color.white)
          .frame(width: screenWidth / 1.5)
          .cornerRadius(10)
        
        TextField("Confirm Password", text: $formConfirmPassword)
          .padding(.all)
          .background(Color.white)
          .frame(width: screenWidth / 1.5)
          .cornerRadius(10)
        
        Button(action: {
          opData.currView = .login
        }) {
          Text("Have an account? Log in")
            .foregroundColor(Color.black)
            .underline(true)
        }.padding()
      }
      AsyncButton(
          "Sign Up",
          action: onCreateAccount
      ).padding(.all)
        .background(Color(red: 0.83, green: 0.25, blue: 0.17))
        .foregroundColor(.white)
        .disabled(!validAccount)
        .cornerRadius(15.0)
      
      Text("Couldn't create account. Please try again.").foregroundColor(validAccount ? Color(red: 0.9, green: 0.71, blue: 0.54) : Color.black)
      
      Spacer()
    }.frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color(red: 0.9, green: 0.71, blue: 0.54))
  }
}

struct CreateAccountView_Previews: PreviewProvider {
  static var previews: some View {
    CreateAccountView()
  }
}
