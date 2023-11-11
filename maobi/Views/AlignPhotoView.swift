//
//  AlignPhotoView.swift
//  maobi
//
//  Created by Dora Xiao on 11/10/23.
//

import SwiftUI

struct AlignPhotoView: View {
  @State var topLeft = CGPoint(x:50,y:350)
  @State var topRight = CGPoint(x:350,y:350)
  @State var bottomLeft = CGPoint(x:50,y:50)
  @State var bottomRight = CGPoint(x:350,y:50)
  @State var zoom = 1.0
  
    var body: some View {
      let inputImage = UIImage(named: "小_warped")!
      let templateImage = UIImage(named: "小_template")!
      
      
//      let transformed = perspectiveCorrection(inputImage, CGPoint(x:37, y:400-353), CGPoint(x:339, y:400-310), CGPoint(x: 295, y:400-158), CGPoint(x:109, y:400-158))
//      Image(uiImage: inputImage)
//      Image(uiImage: transformed)
      

      ZStack(alignment: .topLeading) {
        Image(uiImage: inputImage)
          .scaleEffect(zoom)

        Circle()
          .fill(Color.red)
          .frame(width: 25, height: 25)
          .position(self.topLeft)
          .gesture(
            DragGesture()
              .onChanged { val in
                self.topLeft = val.location
              }
          )
        Circle()
          .fill(Color.red)
          .frame(width: 25, height: 25)
          .position(self.topRight)
          .gesture(
            DragGesture()
              .onChanged { val in
                self.topRight = val.location
              }
          )
        Circle()
          .fill(Color.red)
          .frame(width: 25, height: 25)
          .position(self.bottomLeft)
          .gesture(
            DragGesture()
              .onChanged { val in
                self.bottomLeft = val.location
              }
          )
        Circle()
          .fill(Color.red)
          .frame(width: 25, height: 25)
          .position(self.bottomRight)
          .gesture(
            DragGesture()
              .onChanged { val in
                self.bottomRight = val.location
              }
          )

        // Draw rectangle around overlay
        Path { path in
            path.move(to: topLeft)
            path.addLine(to: topRight)
            path.addLine(to: bottomRight)
            path.addLine(to: bottomLeft)
            path.addLine(to: topLeft)

        }
        .stroke(Color.red)

        // Now sure how to display the image overlay
  //      Image(uiImage: perspectiveCorrection(UIImage(named: "小_warped")!, bottomLeft, bottomRight, topRight, topLeft))


      }

      // slider for zoom
      VStack {
          Slider(value: $zoom, in: 0.25...2.0)
          Text("\(String(format: "Zoom: %.2f", zoom))")
      }


    }
}

struct AlignPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        AlignPhotoView()
    }
}
