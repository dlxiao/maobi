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
//    @State var formUsername : String = "username_2"
//    @State var formPassword : String = "password_2"
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
          .autocapitalization(.none)
          .padding(.all)
          .background(Color.white)
          .frame(width: screenWidth / 1.5)
          .cornerRadius(10)
          .gesture(DragGesture().onChanged({ _ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for :nil)}))

        TextField("password", text: $formPassword)
          .autocapitalization(.none)
          .padding(.all)
          .background(Color.white)
          .frame(width: screenWidth / 1.5)
          .cornerRadius(10)
          .padding()
          .gesture(DragGesture().onChanged({ _ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for :nil)}))

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

// Button Extension for loading or creating user data for the rest of the app
// https://www.swiftbysundell.com/articles/building-an-async-swiftui-button/

struct AsyncButton<Label: View>: View {
    var action: () async -> Void
    var actionOptions = Set(ActionOption.allCases)
    @ViewBuilder var label: () -> Label

    @State private var isDisabled = false
    @State private var showProgressView = false

    var body: some View {
        Button(
            action: {
                if actionOptions.contains(.disableButton) {
                    isDisabled = true
                }
            
                Task {
                    var progressViewTask: Task<Void, Error>?

                    if actionOptions.contains(.showProgressView) {
                        progressViewTask = Task {
                            try await Task.sleep(nanoseconds: 150_000_000)
                            showProgressView = true
                        }
                    }

                    await action()
                    progressViewTask?.cancel()

                    isDisabled = false
                    showProgressView = false
                }
            },
            label: {
                ZStack {
                    label().opacity(showProgressView ? 0 : 1)

                    if showProgressView {
                        ProgressView()
                    }
                }
            }
        )
        .disabled(isDisabled)
    }
}

extension AsyncButton {
    enum ActionOption: CaseIterable {
        case disableButton
        case showProgressView
    }
}

extension AsyncButton where Label == Text {
    init(_ label: String,
         actionOptions: Set<ActionOption> = Set(ActionOption.allCases),
         action: @escaping () async -> Void) {
        self.init(action: action) {
            Text(label)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView()
  }
}
#endif
