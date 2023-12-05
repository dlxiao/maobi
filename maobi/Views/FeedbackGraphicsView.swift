//
//  FeedbackGraphicsView.swift
//  maobi

import WebKit
import SwiftUI
import CoreGraphics
import Combine
import Foundation

struct FeedbackGraphicsView: View {
  @EnvironmentObject var opData : OpData
  @State var selectedStroke = -1

  var body: some View {
    ScrollView {
      let characterString = opData.character?.toString() ?? "default_character"
      let filename = "\(characterString)_template"
      let template = UIImage.init(named: filename)!
      if let submission = opData.cameraModel.transformedImage {
        let averageColor = submission.averageColor(withMask: template)
//        let thresholdedSubmission = binarize(submission, withAverageColor: averageColor)
        let test = binarize(submission)
        let processed = ProcessImage(submission: test, template: template, character: characterString)
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
      }

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
      // TODO: Back Button. fix the location of it
//      Button(action: {
//          opData.currView = opData.lastView.removeLast()
//      }) {
//          HStack {
//              Image(systemName: "chevron.left")
//              Text("Back")
//          }.foregroundColor(.black).font(.title3).fontWeight(.bold)
//      }.frame(maxWidth: .infinity, alignment: .leading)
//      .padding()

      // Finish Button
      Button(action: {
          // opData.user?.updateUserData(...)
          opData.lastView.append(.feedback) // Store the current view
          opData.currView = .home // Navigate to home or next view
      }) {
          Text("Finish").fontWeight(.bold)
      }.padding(.all)
      .background(Color(red: 0.83, green: 0.25, blue: 0.17))
      .foregroundColor(.white)
      .cornerRadius(15.0)
//      Button(action: {
//        //TODO: addback setTotalStars
////        opData.user?.setTotalStars((opData.user?.getTotalStars())! + processed.stars)
//        // TODO: change to this after userLevel set up
//        //      if let userLevel = user.getUserLevel(levels) {
//        //          // Now you have the full UserLevel object
//        //          if processed.stars > userLevel.maxStars {
//        //              user.updateMaxStars(userLevelId: userLevel.userlevelID, newStars: processed.stars)
//        //              user.addTotalStars(processed.stars - userLevel.maxStars)
//        //          }
//        //      } else {
//        //        Text("Invalid UserLevel")
//        //      }
//      }) {
//        NavigationLink(
//          destination: HomeView(),
//          label: { Text("Finish").fontWeight(.bold)
//          })
//      }.padding(.all)
//        .background(Color(red: 0.83, green: 0.25, blue: 0.17))
//        .foregroundColor(.white)
//        .cornerRadius(15.0)
    }
  }
  }
//  func binarize(_ uiimage : UIImage) -> UIImage {
//    var image = CIImage(image: uiimage)!
//    var ciCtx = CIContext()
//    var filter = ThresholdFilter()
//    filter.inputImage = CIImage(image: uiimage, options: [CIImageOption.colorSpace: NSNull()])
//    let outputImage = filter.outputImage
//    let cgimg = ciCtx.createCGImage(outputImage!, from: (outputImage?.extent)!)
//    return UIImage(cgImage: cgimg!)
//  }
}
