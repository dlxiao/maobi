//
//  FeedbackGraphicsView.swift
//  maobi
//
//  Created by Dora Xiao on 11/10/23.
//
import WebKit
import SwiftUI
import CoreGraphics
import Combine
import Foundation


struct FeedbackGraphicsView: View {
  //  @State var html : String
  @State var selectedStroke = -1
  @State var feedbackText = ""
  
  var body: some View {
    let processed = ProcessImage(submissionPath: "submission_good", templatePath: "template", character: "十")
    
    ZStack {
      processed.characterContour
        .stroke(Color.black, lineWidth: 4)
        .background(processed.characterContour.fill(Color.black))
        .frame(width: 250, height: 250)
        .offset(x: 0, y: 0)
      
      if(selectedStroke >= 0) {
        processed.strokes[selectedStroke]
          .stroke(Color.red, lineWidth: 4)
          .background(processed.strokes[selectedStroke].fill(Color.red))
          .frame(width: 250, height: 250)
          .offset(x: 0, y: 0)
      }
      
    }.onTapGesture { location in
      selectedStroke = processed.shapeClicked(location)
    }
    
  }
  
}
