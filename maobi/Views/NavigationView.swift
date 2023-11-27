import SwiftUI

struct NavigationView: View {
  
  @EnvironmentObject var opData : OpData
  
  var body: some View {
    switch(opData.currView){
    // Given this new navigation, can condition from Firebase about whether user has done tutorial before
    case .onboarding: OnboardingView().environmentObject(opData)
    case .tutorial: TutorialView().environmentObject(opData)
    case .login: LoginView().environmentObject(opData)
    case .home: HomeView().environmentObject(opData)
    case .strokelist: StrokeListView().environmentObject(opData)
    case .characterlist: CharacterListView().environmentObject(opData)
    case .level: LevelView().environmentObject(opData)
    case .menu: MenuView().environmentObject(opData)
    case .createaccount: CreateAccountView().environmentObject(opData)
    }
  }
}
