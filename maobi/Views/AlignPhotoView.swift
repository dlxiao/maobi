//
//  AlignPhotoView.swift
//  maobi
//
//  Created by Dora Xiao on 11/10/23.
//

import SwiftUI
import PhotosUI

func inBounds(_ topLeft : (Double, Double), _ bottomRight : (Double, Double), _ pt : (Double, Double)) -> Bool {
  return pt.0 > topLeft.0 && pt.0 < bottomRight.0 && pt.1 > topLeft.1 && pt.1 < bottomRight.1
}

struct AlignPhotoView: View {
  var levels : Levels
  var character : String
  @State var topLeft = (0,UIScreen.main.bounds.width)
  @State var bottomRight = (UIScreen.main.bounds.width,0)
  @State var zoom = 0.5
  @State var translation = (0.0, 0.0)
  var screenWidth = UIScreen.main.bounds.width
  @State var size = UIScreen.main.bounds.width * 0.5
  
    var body: some View {
      let inputImage = UIImage(named: "小_thin")!
      let templateImage = UIImage(named: "小_template")!
      
      ZStack {
        VStack {
          Text("Confirm your alignment").font(.title).padding([.bottom]).zIndex(1)
          
          ZStack {
            Image(uiImage: inputImage)
              .scaleEffect(zoom)
              .offset(x: self.translation.0, y:self.translation.1)
              .border(.red, width: 3)
//              .gesture(DragGesture()
//                .onChanged({ val in
//                  self.translation = (val.location.x - val.startLocation.x, val.location.y - val.startLocation.y)
//                })) // disabling drag for now bc can't get alignment working
            Image(uiImage: templateImage)
              .scaleEffect(0.5)
              .opacity(0.3)
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
      }
      
      VStack {
        Text("\(String(format: "Zoom: %.2f", zoom))").zIndex(1)
        Slider(value: $zoom, in: 0.5...2.0).zIndex(1)
        
        
        Button(action: {}) {
          NavigationLink(
            destination: FeedbackGraphicsView(levels: levels, translation: self.translation, zoom: self.zoom, submission: inputImage, character: self.character),
            label: { Text("Submit Photo").fontWeight(.bold)
            })
        }.padding(.all)
          .background(Color(red: 0.83, green: 0.25, blue: 0.17))
          .foregroundColor(.white)
          .cornerRadius(15.0)
        
      }.background(Color.white)


    }
}
