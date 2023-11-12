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
  var character : String
  var levels : Levels
  var cameraModel : CameraModel
  @State var topLeft = (0,UIScreen.main.bounds.width)
  @State var bottomRight = (UIScreen.main.bounds.width,0)
  @State var zoom = 0.5
  @State var translation = (0.0, 0.0)
  var screenWidth = UIScreen.main.bounds.width
  @State var size = UIScreen.main.bounds.width * 0.5
  
    var body: some View {
//      let inputImage = resizeImage(image: squareCrop(cameraModel.image!), newWidth: 400)!
      let inputImage = threshold(cameraModel.composedImage!)
      
      
      let templateImage = UIImage(named: "\(character)_template")!
      
//      Image(uiImage: inputImage)
      VStack{
        
        ZStack {
          VStack {
            Text("Confirm your alignment").font(.title).padding([.bottom]).zIndex(2).foregroundStyle(Color.black)
            
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
          Text("\(String(format: "Zoom: %.2f", zoom))").zIndex(1).foregroundStyle(Color.black)
          Slider(value: $zoom, in: 0.5...2.0).zIndex(1).padding()
          
          
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
        
      }.background(Color.white)
    }
}


func squareCrop(_ image : UIImage) -> UIImage {
  let subCI = CIImage(image: image)!
  let context = CIContext(options: nil)
  let subCG = context.createCGImage(subCI, from: subCI.extent)!
  
  let imgWidth = subCG.width
  let imgHeight = subCG.height
  let cropRect = CGRect(x: 0, y: 0, width: imgWidth, height: imgWidth)
  let result = subCG.cropping(to: cropRect)!
  return UIImage(cgImage: result)
}



func threshold(_ inputImage : UIImage) -> UIImage {
  var currentCGImage = inputImage.cgImage!
  var currentCIImage = CIImage(cgImage: currentCGImage)

  let filter = CIFilter(name: "CIColorMonochrome")
  filter?.setValue(currentCIImage, forKey: "inputImage")

  // set a gray value for the tint color
  filter?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")

  filter?.setValue(1.0, forKey: "inputIntensity")
  var outputImage = filter?.outputImage!

  var context = CIContext()

  let cgimg = context.createCGImage(outputImage!, from: outputImage!.extent)!
  let processedImage = UIImage(cgImage: cgimg)
  
  return processedImage
}
