
import SwiftUI

// Starting point
// With topbar and tabs
struct TestNavView: View {
    @EnvironmentObject var viewModel: ViewModel
    var levels = Levels()
    var body: some View {
      
      TopBarView()
      ZStack{
          TabView {
              TutorialOneView(levels: levels)
                  .tabItem {
                      Label("Home", systemImage: "house.fill")
                  }
              MenuView(levels: levels)
                  .tabItem {
                      Label("Menu", systemImage: "person.fill")
                  }
          }
          .accentColor(Color(red: 0.9, green: 0.71, blue: 0.54))
          VStack{
              Spacer()
              if !viewModel.isTabViewEnabled{
                  Rectangle()
                      .fill(Color.white.opacity(0.001))
                      .frame(width: .infinity, height: 50)
              }
          }

      }
    
  }
}


struct HomeViewTest: View {
  var levels : Levels
  var body: some View {
    VStack {
      NavigationLink(destination: StrokeListView(levels: levels)) { Text("Strokes") }
      NavigationLink(destination: CharacterListView(levels: levels)) { Text("Characters") }
    }.navigationBarTitle("")
      .navigationBarBackButtonHidden(true)
      .navigationBarHidden(true)
    
  }
}

struct MenuViewTest: View {
  var body: some View {
    NavigationView {
      VStack {
        Text("placeholder menu stuff")
      }
    }
  }
}

struct TutorialViewTest: View {
  var levels : Levels
  var body: some View {
    NavigationView {
      VStack {
        NavigationLink(destination: OnboardingViewTest(levels: levels)) { Text("Finish tutorial, go to onboarding") }
      }
    }.navigationBarTitle("")
      .navigationBarBackButtonHidden(true)
      .navigationBarHidden(true)
  }
}

struct OnboardingViewTest : View {
  var levels : Levels
  var body: some View {
      VStack {
        NavigationLink(destination: HomeView(levels: levels)) { Text("Finish onboarding, go to home") }
      }.navigationBarTitle("")
      .navigationBarBackButtonHidden(true)
      .navigationBarHidden(true)
  }
}


