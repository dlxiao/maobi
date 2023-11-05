
import SwiftUI

// Starting point
// With topbar and tabs
struct TestNavView: View {
  var levels = Levels()
  var body: some View {
    TopBarView()
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


