//
//  HomeView.swift
//  maobi
//
//  Created by Dora Xiao on 10/23/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
      TabView {

        TutorialView(text:getTutorial())
        .tabItem {
            Image(systemName: "house.fill")
            Text("Tutorial Demo")
        }

        LevelView()
        .tabItem {
            Image(systemName: "list.dash")
            Text("Character Demo")
        }
        
      }
      
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
