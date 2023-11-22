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
  @State var formEmail : String = ""
  @State var formUsername : String = ""
  @State var formPassword : String = ""
  @State var formConfirmPassword : String = ""
  private var validAccount = false
  
  // async completion handler for creating account
  func onCreateAccount() async -> Void {
//    var userRepo = UserRepository("sampleuser_1")
//    self.opData.user = userRepo
//    userRepo.loadUser() { userResult in
//      if let user = userResult {
//        if(user.completedTutorial) {
//          opData.currView = .home
//        } else {
//          opData.currView = .onboarding
//        }
//      } else {
//        print("Couldn't fetch user")
//      }
//    }
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
        
        Button(action: {}) {
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
