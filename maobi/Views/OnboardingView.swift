//
//  OnboardingView.swift
//  maobi
//
//  Created by Lucy on 11/2/23.
//

import SwiftUI

struct OnboardingView: View {
  var levels : Levels
  var user : UserRepository
  let horizontal = FingerDraw(character: "一", size: 700)
  let vertical = FingerDraw(character: "丨", size: 800)
  let ten = FingerDraw(character: "十", size: 500)
  
  @State private var currentPage: Int = 0
  @State private var navigateToPage2: Bool = false  // Add this state variable
  
  @State private var moveDistance: CGFloat = 15 // This determines how much the image will move left or right
  @State private var moveRight = true // This will determine the direction of movement
  @State private var moveUp = false
  
  @State private var navigateToHome: Bool = false
  
    @EnvironmentObject var viewModel: ViewModel
    
  var body: some View {
    NavigationView {
      TabView(selection: $currentPage) {
        VStack {
          Spacer()
          Text("Welcome!")
            .font(.largeTitle)
            .bold()
          Spacer()
          
          Button(action: {
            currentPage = 1  // Set currentPage to the next page
          }) {
            Text("Get Started >")
              .font(.largeTitle)
              .foregroundColor(.red)
          }
          .padding(.bottom, 300)
        }
        .padding()
        .tabItem { Text("Onboarding") }
        .tag(0)
        
        ZStack {
          VStack {
            Text("Try this Stroke:")
              .font(.largeTitle)
              .padding()
            Spacer()
            FingerDrawView(html: horizontal.getQuizHTML())
              .offset(x: 30, y: 120)
            Spacer()
            HStack {
              Spacer() // Pushes the button to the right
              Button(action: {
                currentPage = 2  // Navigate to "Onboarding 3"
              }) {
                Image("forwardIcon")  // Using the forwardIcon asset for the rest of the buttons
                  .resizable()
                  .scaledToFit()
                  .frame(width: 50, height: 50)
              }
              .padding() // Adds some padding so the button isn't right up against the edge
            }
          }
          Image("finger1")
            .resizable()  // Make the image resizable
            .scaledToFit()  // Scale to fit within its bounding frame
            .frame(width: UIScreen.main.bounds.width * 0.4)  // Set to 80% of screen width
            .offset(x: (moveRight ? -moveDistance : moveDistance) + 80, y: 80)  // Additional offset to move it slightly to the right and down
            .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: false))
            .onAppear() {
              moveRight.toggle()
            }
        }
        .tabItem { Text("Onboarding 2") }
        .tag(1)
        
        VStack {
          Text("Nice work!")
            .font(.largeTitle)
            .padding()
          Spacer()
          Image("horizontal")
            .resizable()
            .font(.footnote)
            .padding()
          Spacer()
          HStack {
            Spacer() // Pushes the button to the right
            Button(action: {
              currentPage = 3  // Navigate to "Onboarding 4"
            }) {
              Image("forwardIcon")  // Using the forwardIcon asset for the rest of the buttons
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            }
            .padding() // Adds some padding so the button isn't right up against the edge
          }
        }
        .tabItem { Text("Onboarding 3") }
        .tag(2)
        
        ZStack {
          VStack {
            Text("Let's try this one:")
              .font(.system(size: 30))
              .padding()
            Spacer()
            FingerDrawView(html: vertical.getQuizHTML())
              .offset(x: 30, y: 120)
            Spacer()
            HStack {
              Spacer() // Pushes the button to the right
              Button(action: {
                currentPage = 4  // Navigate to "Onboarding 5"
              }) {
                Image("forwardIcon")  // Using the forwardIcon asset for the rest of the buttons
                  .resizable()
                  .scaledToFit()
                  .frame(width: 50, height: 50)
              }
              .padding() // Adds some padding so the button isn't right up against the edge
            }
          }
          Image("finger2")
            .resizable()  // Make the image resizable
            .scaledToFit()  // Scale to fit within its bounding frame
            .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.25)
            .offset(x: 80, y: (moveUp ? moveDistance : -moveDistance) + 50)  // Hover up and down
            .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: false))
            .onAppear() {
              moveUp.toggle()
            }
        }
        .tabItem { Text("Onboarding 4") }
        .tag(3)
        
        VStack {
          Text("Nice work!")
            .font(.largeTitle)
            .padding()
          Spacer()
          Image("vertical")
            .resizable()
            .font(.footnote)
            .padding()
          Spacer()
          HStack {
            Spacer() // Pushes the button to the right
            Button(action: {
              currentPage = 5  // Navigate to "Onboarding 4"
            }) {
              Image("forwardIcon")  // Using the forwardIcon asset for the rest of the buttons
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            }
            .padding() // Adds some padding so the button isn't right up against the edge
          }
        }
        .tabItem { Text("Onboarding 5") }
        .tag(4)
        
        VStack {
          Text("Let's put it together")
            .font(.largeTitle)
            .padding()
          Spacer()
          Text("This is the Chinese character for '10'.")
            .padding()
          Text("Order matters. This character has the following stroke order:")
            .padding()
          // Stroke order images here
          HStack(spacing: 30) {
            Image("ten1")
              .resizable()
              .scaledToFit()
              .frame(width: 100)  // or whatever size you desire
            
            Image("ten2")
              .resizable()
              .scaledToFit()
              .frame(width: 100)  // or whatever size you desire
          }
          Spacer()
          Text("Try it out!")
            .font(.largeTitle)
            .padding([.top])
          FingerDrawView(html: ten.getQuizHTML())
            .offset(x: 70, y: 25)
          HStack {
            Spacer() // Pushes the button to the right
            Button(action: {
              currentPage = 6  // Navigate to "Onboarding 7"
            }) {
              Image("forwardIcon")  // Using the forwardIcon asset for the rest of the buttons
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            }
            .padding() // Adds some padding so the button isn't right up against the edge
          }
        }
        .tabItem { Text("Onboarding 6") }
        .tag(5)
        
        VStack {
          Text("Let's put it together")
            .font(.largeTitle)
            .padding()
          Spacer()
          Text("This is the Chinese character for '10'.")
            .padding()
          Text("Order matters. This character has the following stroke order:")
            .padding()
          // Stroke order images here
          HStack(spacing: 30) {
            Image("ten1")
              .resizable()
              .scaledToFit()
              .frame(width: 100)  // or whatever size you desire
            
            Image("ten2")
              .resizable()
              .scaledToFit()
              .frame(width: 100)  // or whatever size you desire
          }
          Spacer()
          Text("Nice!")
            .font(.system(size: 30))
            .padding()
          Image("ten")
            .resizable()
            .frame(width: 180, height: 189.95)
            .font(.footnote)
            .padding()
          HStack {
            Spacer() // Pushes the button to the right
            Button(action: {
              currentPage = 7  // Navigate to "Onboarding 8"
            }) {
              Image("forwardIcon")  // Using the forwardIcon asset for the rest of the buttons
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            }
            .padding() // Adds some padding so the button isn't right up against the edge
          }
        }
        .tabItem { Text("Onboarding 7") }
        .tag(6)
        
        VStack {
          NavigationLink("", destination: TutorialOneView(levels: levels, user: user), isActive: $navigateToHome)
            .hidden()
          Text("You just wrote a Chinese character!")
            .font(.largeTitle)
            .multilineTextAlignment(.center)
            .padding()
            
          Spacer()
          Text("Although we just wrote using a touch screen, the rest of this app is for practicing **physical** calligraphy")
                .padding(30)
            
          Spacer()
          Text("Recommended Materials:")
            .padding()
          VStack {
            HStack(spacing: 30) {
              Image("ink brush")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
              
              Image("Rice Paper")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
            }
            HStack(spacing: 30) {
              Image("Chinese Ink")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
              
              Image("ink stone")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
            }
          }
          .padding()
          Text("You can access this information any time from the home screen.")
            .font(.system(size: 10))
            .foregroundColor(.gray)
          HStack {
            Spacer() // Pushes the button to the right
            Button(action: {
              navigateToHome = true
            }) {
              Image("forwardIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            }
            
            .padding() // Adds some padding so the button isn't right up against the edge
          }
        }
        .tabItem { Text("Onboarding 8") }
        .tag(7)
        
      }
      .onAppear{viewModel.isOnboardingEnabled = true}
      .onDisappear{viewModel.isOnboardingEnabled = false}
      .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide the default navigation dots
      .onChange(of: currentPage, perform: { value in
        if value == 1 {
          navigateToPage2 = true
        }
      })
    }
    .navigationBarTitle("")
      .navigationBarBackButtonHidden(true)
      .navigationBarHidden(true)
  }
}
