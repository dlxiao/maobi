// This file contains camera feature stuff

import CoreImage
import SwiftUI
import Foundation
import UIKit

// TODO
//func getOverlay(_ character : String) -> Image {
//  return
//}

// TODO
func getFeedback(_ character : CharacterData, _ image : UIImage) -> Dictionary<String, String> {
  let stars = Int.random(in: 1...3) // depends on image processing
  
  var msg : String // msg depends on stars
  if(stars == 1) {
    msg = "Try again."
  } else if (stars == 2) {
    msg = "Good progress!"
  } else {
    msg = "Awesome work!"
  }
  
  let alignment = "alignment msg"
  
  let thickness = "thickness msg"
  
  var feedback = [
    "stars": String(stars),
    "message": msg,
    "strokeOrder": "not for MVP",
    "thickness": thickness,
    "alignment": alignment
    
  ]
  return feedback
}



func perspectiveTransform() -> UIImage {
  
  let inputImage = CIImage(image: UIImage(named: "submission_good")!)!
  
  let context = CIContext()
  
  let sepiaFilter = CIFilter(name:"CIPerspectiveTransform")
  sepiaFilter?.setValue(inputImage, forKey: kCIInputImageKey)
  sepiaFilter?.setValue(CIVector(cgPoint: CGPoint(x:0, y:200)), forKey: "inputTopLeft")
  sepiaFilter?.setValue(CIVector(cgPoint: CGPoint(x:100, y:100)), forKey: "inputTopRight")
  sepiaFilter?.setValue(CIVector(cgPoint: CGPoint(x:0, y:0)), forKey: "inputBottomLeft")
  sepiaFilter?.setValue(CIVector(cgPoint: CGPoint(x:100, y:0)), forKey: "inputBottomRight")
  let sepiaCIImage = sepiaFilter?.outputImage
  let cgOutputImage = context.createCGImage(sepiaCIImage!, from: inputImage.extent)!
  
  return UIImage(cgImage: cgOutputImage)
}
