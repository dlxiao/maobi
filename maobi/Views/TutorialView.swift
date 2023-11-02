//
//  TutorialView.swift
//  maobi
//
//  Created by Teresa Yuefan Yang on 11/1/23.
//

import SwiftUI

struct TutorialView: View {
    @State private var step = 0
    @State private var isTutorialDone = false
    
    var body: some View {
        ZStack{
            HomeView().disabled(true)
            
            if step == 0{
                
                ZStack{
                    Color.black.opacity(0.6).ignoresSafeArea()
                    Circle()
                        .frame(width: 200, height: 200)
                        .blendMode(.destinationOut)
                        .offset(x: -80, y: -110)
                    
                }
                .compositingGroup()
                Text("Learn and practice the 8 basic strokes")
                    .foregroundColor(Color.white)
                    .frame(width: 200)
                    .offset(x: -80, y: -250)
            } else if step == 1 {
                ZStack{
                    Color.black.opacity(0.6).ignoresSafeArea()
                    Circle()
                        .frame(width: 200, height: 200)
                        .blendMode(.destinationOut)
                        .offset(x: 80, y: -110)
                    
                }
                .compositingGroup()
                Text("Learn stroke order and practice basic characters")
                    .foregroundColor(Color.white)
                    .frame(width: 200)
                    .offset(x: 80, y: -250)

            } else if step == 2 {
                ZStack{
                    Color.black.opacity(0.6).ignoresSafeArea()
                    Circle()
                        .frame(width: 200, height: 200)
                        .blendMode(.destinationOut)
                        .offset(x: -80, y: 140)
                    
                }
                .compositingGroup()
                Text("Learn and practice characters of a specific topic")
                
                    .foregroundColor(Color.white)
                    .frame(width: 200)
                    .offset(x: -80, y: 10)
            } else if step == 3 {
                ZStack{
                    Color.black.opacity(0.6).ignoresSafeArea()
                    Circle()
                        .frame(width: 100, height: 100)
                        .blendMode(.destinationOut)
                        .offset(x: 170, y: -370)
                    
                }
                .compositingGroup()
                Text("Earn stars through practicing! Stars can unlock more characters")
                
                    .foregroundColor(Color.white)
                    .frame(width: 150)
                    .offset(x: 100, y: -270)

            } else if step == 4 {
                ZStack{
                    Color.black.opacity(0.6).ignoresSafeArea()
                    Circle()
                        .frame(width: 200, height: 200)
                        .blendMode(.destinationOut)
                        .offset(x: 80, y: 140)
                    
                }
                .compositingGroup()
                Text("Unlock a character every day by doing a daily challenge!")
                
                    .foregroundColor(Color.white)
                    .frame(width: 150)
                    .offset(x: 80, y: 0)

                
            } else if step == 5 {
                ZStack{
                    Color.black.opacity(0.6).ignoresSafeArea()
                    VStack{
                        Text("You're all set.").font(.largeTitle).fontWeight(.bold).foregroundColor(.white).padding()
                        Text("Have fun!").font(.largeTitle).fontWeight(.bold).foregroundColor(.white).padding()
                    }
                }

            } else if step > 5{
                HomeView().disabled(false)
                
            }
            if isTutorialDone == false{
                Button(action: {
                    if step <= 5 {
                        step += 1
                    }
                }){
                    Text("Next").foregroundColor(.white)
                }
                .offset(x: 150, y: 400)
                
                Button(action: {
                    if step >= 1 {
                        step -= 1
                    }
                }){
                    Text("Back").foregroundColor(.white)
                }
                .offset(x: -150, y: -300)
            
            }


            
            
        }
        
        
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
