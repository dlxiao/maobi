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
  @State var errorMsg = "Couldn't create account. Please try again."
  let emailValidation = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
  
  // async completion handler for creating account
  func onCreateAccount() async -> Void {
    // validation
    if(formPassword != formConfirmPassword) {
      validAccount = false
      errorMsg = "Passwords don't match."
    } else if (!emailValidation.evaluate(with: formEmail)) {
      validAccount = false
      errorMsg = "Invalid email."
    } else {
      // create account
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
          errorMsg = "Username already exists"
        }
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
          .gesture(DragGesture().onChanged({ _ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for :nil)}))
        
        TextField("Email", text: $formEmail)
          .padding(.all)
          .background(Color.white)
          .frame(width: screenWidth / 1.5)
          .cornerRadius(10)
          .gesture(DragGesture().onChanged({ _ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for :nil)}))

        
        TextField("Password", text: $formPassword)
          .padding(.all)
          .background(Color.white)
          .frame(width: screenWidth / 1.5)
          .cornerRadius(10)
          .gesture(DragGesture().onChanged({ _ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for :nil)}))

        
        TextField("Confirm Password", text: $formConfirmPassword)
          .padding(.all)
          .background(Color.white)
          .frame(width: screenWidth / 1.5)
          .cornerRadius(10)
          .gesture(DragGesture().onChanged({ _ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for :nil)}))

        
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
        .cornerRadius(15.0)
      
      Text(errorMsg).foregroundColor(validAccount ? Color(red: 0.9, green: 0.71, blue: 0.54) : Color.black)
      
      Spacer()
    }.frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color(red: 0.9, green: 0.71, blue: 0.54))
  }
}

//struct CreateAccountView_Previews: PreviewProvider {
//  static var previews: some View {
//    CreateAccountView()
//  }
//}
