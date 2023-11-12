
import SwiftUI

// Starting point
// With topbar and tabs
struct TestNavView: View {
    @EnvironmentObject var viewModel: ViewModel

    @State private var selectedTab = 0
    
    
    var levels = Levels()
    var user = UserRepository()
    var body: some View {
      
      TopBarView(user: user)
      ZStack{
          TabView(selection: $selectedTab) {
            OnboardingView(levels: levels, user: user)
                  .tabItem {
                      Label("Home", systemImage: "house.fill")
                  }
                  .tag(0)
              MenuView(levels: levels, user: user)
                  .tabItem {
                      Label("Menu", systemImage: "person.fill")
                  }
                  .tag(1)
          }
          .accentColor(Color(red: 0.9, green: 0.71, blue: 0.54))
          .onChange(of: selectedTab){
              selected in
              if selected == 0 {
                  viewModel.menuView = false
              }
              else if selected == 1 {
                  viewModel.menuView = true
              }
          }
          VStack{
              Spacer()
              if !viewModel.isTabViewEnabled{
                  Rectangle()
                      .fill(Color.white.opacity(0.001))
                      .frame(width: .infinity, height: 50)
              }
              
              else if viewModel.isOnboardingEnabled{
                  Rectangle()
                      .fill(Color.white)
                      .frame(width: .infinity, height: 40)

              }
          }
          

      }
    
  }
}

