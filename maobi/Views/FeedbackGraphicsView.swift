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


func binarize(_ uiimage : UIImage) -> UIImage {
  var image = CIImage(image: uiimage)!
  var ciCtx = CIContext()
  var filter = ThresholdFilter()
  filter.inputImage = CIImage(image: uiimage, options: [CIImageOption.colorSpace: NSNull()])
  let outputImage = filter.outputImage
  let cgimg = ciCtx.createCGImage(outputImage!, from: (outputImage?.extent)!)
  return UIImage(cgImage: cgimg!)
}


struct FeedbackGraphicsView: View {
  //  @State var html : String
  var levels : Levels
  var translation : (Double, Double)
  var zoom : Double
  var submission : UIImage
  var character : String
  var user : UserRepository
  
  @State var selectedStroke = -1
  
  var body: some View {
    let template = UIImage.init(named: "\(self.character)_template")!
    let transformed = transformSubmission(submissionZoom: self.zoom, templateZoom: 0.5, translation: self.translation, submission: self.submission, template: template)
    let test = binarize(submission)
    let processed = ProcessImage(submission: test, template: template, character: character)

//    Image(uiImage: test)
//
//    VStack {
//      ZStack {
//        Spacer()
//        Image(uiImage: transformed)
//          .border(.green, width: 3)
//          .scaleEffect(0.8)
//        Image(uiImage: template)
//          .opacity(0.3)
//          .scaleEffect(0.8)
//
//      }
//    }.frame(maxWidth: .infinity, maxHeight: .infinity)
  
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
            .offset(x: 0, y:-15)
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
    .background(Color.white)

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

    Button(action: {}) {
      NavigationLink(
        destination: HomeView(levels: levels, user: user),
        label: { Text("Finish").fontWeight(.bold)
        })
    }.padding(.all)
      .background(Color(red: 0.83, green: 0.25, blue: 0.17))
      .foregroundColor(.white)
      .cornerRadius(15.0)
  }
  
}
