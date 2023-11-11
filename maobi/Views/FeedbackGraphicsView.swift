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
  let processed = ProcessImage(submissionPath: "小_template", templatePath: "小_template", character: "小")
  @State var selectedStroke = -1
  
  var body: some View {
    
//    let processed = ProcessImage(submissionPath: "submission_good", templatePath: "template", character: "十")
    
    // Overall message
    Text(processed.overallMsg).font(.largeTitle)
    
    // Stars
    HStack {
      if(processed.stars == 0) {
      } else if (processed.stars == 1) {
        Image("star")
      } else if (processed.stars == 2) {
        Image("star")
        Image("star")
      } else {
        Image("star")
        Image("star")
        Image("star")
      }
    }.padding(.bottom)
    
    
    // Image overlaid with strokes, clickable
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
        
        processed.templateStrokes[selectedStroke]
          .stroke(Color.yellow, lineWidth: 2)
          .frame(width: 250, height: 250)
          .offset(x: 0, y: 0)
      }
      
    }.onTapGesture { location in
//      print("Clicked \(location)")
      selectedStroke = processed.shapeClicked(location)
      }
    .padding(.bottom)
    
    // Feedback Messages
    VStack {
      HStack(alignment: .top) {
        Text("Thickness: ")
        if(selectedStroke == -1) {
          Text(processed.thicknessMsg)
        } else {
          Text(processed.feedback[selectedStroke]["thickness"]!)
        }
      }
      HStack{
        Text("Alignment: ")
        if(selectedStroke == -1) {
          Text(processed.alignmentMsg)
        } else {
          Text(processed.feedback[selectedStroke]["alignment"]!)
        }
      }
      HStack{
        Text("Stroke Order: ")
        if(selectedStroke == -1) {
          Text(processed.strokeorderMsg)
        } else {
          Text(processed.feedback[selectedStroke]["strokeOrder"]!)
        }
      }
      
    }
    
    
    
  }
  
}
