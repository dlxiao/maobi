//
//  FeedbackView.swift
//  maobi
//
//  Created by Dora Xiao on 11/1/23.
//

import SwiftUI

struct FeedbackView: View {
  var feedback : Dictionary<String, String>
  var levels : Levels
  var user : UserRepository

  var body: some View {
    Text(feedback["message"]!) // depends on number of stars
      .font(.largeTitle)
      .padding([.bottom], 50)
    HStack{
      ForEach(1...Int(feedback["stars"]!)!, id: \.self) { starNum in
        Image("star")
      }
    }.padding([.bottom], 50)

    // Individual Feedback
    Text("Thickness: " + feedback["thickness"]!)
    Text("Alignment: " + feedback["alignment"]!)
    Text("Stroke order: " + feedback["strokeOrder"]!)

    NavigationLink(
      destination: HomeView(),
        label: {
            Text("Finish").fontWeight(.bold)
        }).padding(.all)
      .background(Color(red: 0.83, green: 0.25, blue: 0.17))
      .foregroundColor(.white)
      .cornerRadius(15.0)
      .padding([.top], 50)

  }
}
