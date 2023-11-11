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
  var submission : UIImage
  var character : String
  
  @State var selectedStroke = -1
  
  var body: some View {
    let template = UIImage.init(named: "\(character)_template")!
    let processed = ProcessImage(submission: submission, template: template, character: character)
    
    // Overall message
    Text(processed.overallMsg).font(.title)
    
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
        if(processed.invalid) {
          // display template contour over submission to show misalignment
          CharacterContour(processed.submissionPts).stroke(Color.black, lineWidth: 4)
            .background(processed.characterContour.fill(Color.black))
            .frame(width: 250, height: 250)
            .offset(x: 0, y: 0)
          CharacterContour(processed.templatePts).stroke(Color.red, lineWidth: 4)
            .frame(width: 250, height: 250)
            .offset(x: 0, y: 0)
        } else { // clickable strokes
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
        
        }
      
    }.onTapGesture { location in
      print("Clicked \(location)")
      selectedStroke = processed.shapeClicked(location)
      }
    .padding(.bottom)
    
    // Feedback Messages
    if(!processed.invalid) {
      VStack {
        HStack(alignment: .top) {
          Text("Thickness: ")
          if(selectedStroke == -1) {
            Text(processed.thicknessMsg)
          } else {
            Text(processed.feedback[selectedStroke]["thickness"]!)
          }
        }.padding()
        HStack(alignment: .top){
          Text("Alignment: ")
          if(selectedStroke == -1) {
            Text(processed.alignmentMsg)
          } else {
            Text(processed.feedback[selectedStroke]["alignment"]!)
          }
        }.padding()
        HStack(alignment: .top){
          Text("Stroke Order: ")
          if(selectedStroke == -1) {
            Text(processed.strokeorderMsg)
          } else {
            Text(processed.feedback[selectedStroke]["strokeOrder"]!)
          }
        }.padding()
        
      }
    }
    
    
  }
  
}
