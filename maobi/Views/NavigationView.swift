import SwiftUI

struct NavigationView: View {
  
  @EnvironmentObject var opData : OpData
  
  var body: some View {
#if !TESTING
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
    case .camera: CameraView().environmentObject(opData)
    case .alignment: GestureAlignmentView().environmentObject(opData)
    case .feedback: FeedbackGraphicsView().environmentObject(opData)
    case .dailychallenge: DailyChallengeView().environmentObject(opData)
    }
#endif
  }
}
