//
//  OnboardingView.swift
//  maobi
//
//  Created by Dora Xiao on 11/15/23.
//

import SwiftUI

#if !TESTING
struct OnboardingView: View {
  @EnvironmentObject var opData : OpData
  @State var page = 1
  let horizontal = FingerDraw(character: "一", size: 800)
  let vertical = FingerDraw(character: "丨", size: 800)
  let ten = FingerDraw(character: "十", size: 600)
  
  @State private var moveDistance: CGFloat = 15 // This determines how much the image will move left or right
  @State private var moveRight = true // This will determine the direction of movement
  @State private var moveUp = false
  
  var body: some View {
    if(page == 1) {
      VStack {
        Spacer()
        Image("maobi_logo")
        Button(action: {
          self.page += 1
        }) {
          HStack {
            Text("GET STARTED ")
              .foregroundColor(.white)
              .fontWeight(.bold)
              .font(.largeTitle)
            Image(systemName: "chevron.right.2")
              .foregroundColor(.white)
              .fontWeight(.bold)
              .font(.largeTitle)
          }
        }
        Spacer()
      }.frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.9, green: 0.71, blue: 0.54))
    } else if(page == 2) {
      ZStack {
        
        
        FingerDrawView(html: horizontal.getIndividualQuizHTML())
        Image("finger1")
          .resizable()  // Make the image resizable
          .scaledToFit()  // Scale to fit within its bounding frame
          .frame(width: UIScreen.main.bounds.width * 0.4)  // Set to 80% of screen width
          .offset(x: (moveRight ? -moveDistance : moveDistance) + 80, y: 120)  // Additional offset to move it slightly to the right and down
          .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: false))
          .onAppear() {
            moveRight.toggle()
          }
      }
      HStack{
        Spacer()
        Button(action: {
          self.page += 1
        }) {
          Image(systemName: "chevron.right.2")
            .foregroundColor(.black)
            .fontWeight(.bold)
            .font(.largeTitle)
        }.padding([.trailing])
      }
      
    } else if(page == 3) {
      ZStack{
        FingerDrawView(html: vertical.getIndividualQuizHTML())
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
      
      HStack{
        Spacer()
        Button(action: {
          self.page += 1
        }) {
          Image(systemName: "chevron.right.2")
            .foregroundColor(.black)
            .fontWeight(.bold)
            .font(.largeTitle)
        }.padding([.trailing])
      }
    } else if(page == 4) {
      VStack {
        Text("Let's put it together").padding([.top], 50)
          .font(.largeTitle)
        Text("This is the Chinese character for '10'. \nOrder matters. This character has the following stroke order:")
          .fixedSize(horizontal: false, vertical: true)
          .padding(30)
        // Stroke order images here
        HStack(spacing: 30) {
          Image("ten1")
            .resizable()
            .scaledToFit()
            .frame(height: 80)
          
          Image("ten2")
            .resizable()
            .scaledToFit()
            .frame(height: 80)
        }
        FingerDrawView(html: ten.getIndividualQuizHTML())
      }
      
      HStack{
        Spacer()
        Button(action: {
          self.page += 1
        }) {
          Image(systemName: "chevron.right.2")
            .foregroundColor(.black)
            .fontWeight(.bold)
            .font(.largeTitle)
        }.padding([.trailing])
      }
    } else {
      VStack {
        Text("You just wrote a Chinese character!")
          .font(.largeTitle)
          .multilineTextAlignment(.center)
          .padding()
        Text("Although we just wrote using a touch screen, the rest of this app is for practicing **physical** calligraphy. We recommend these materials: ")
          .padding([.leading, .trailing])
        VStack {
          HStack{
            Image("ink brush")
              .resizable()
              .scaledToFit()
              .frame(width: screenWidth / 2.5)
            
            Image("rice paper")
              .resizable()
              .scaledToFit()
              .frame(width: screenWidth / 2.5)
          }
          HStack{
            Image("chinese ink")
              .resizable()
              .scaledToFit()
              .frame(width: screenWidth / 2.5)
            
            Image("ink stone")
              .resizable()
              .scaledToFit()
              .frame(width: screenWidth / 2.5)
          }
        }
        .padding()
        Text("You can access this information any time from the home screen.")
          .font(.system(size: 10))
          .foregroundColor(.gray)
      }.padding(50)
      HStack{
        Spacer()
        Button(action: {
          opData.lastView.append(.onboarding)
          opData.currView = .tutorial
        }) {
          Image(systemName: "chevron.right.2")
            .foregroundColor(.black)
            .fontWeight(.bold)
            .font(.largeTitle)
        }.padding([.trailing, .top])
      }
    }
  }
}

struct OnboardingView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingView()
  }
}
#endif
