import UIKit
import CoreImage


// given the input UIImage, perform perspective transformation to the
// four bounding points
func perspectiveTransform(_ input : UIImage) -> UIImage {
  
  let inputImage = CIImage(image: input)!
  let context = CIContext()
  
  let transformFilter = CIFilter(name:"CIPerspectiveTransform")
  transformFilter?.setValue(inputImage, forKey: kCIInputImageKey)
  transformFilter?.setValue(CIVector(cgPoint: CGPoint(x:0,y:250)), forKey: "inputTopLeft")
  transformFilter?.setValue(CIVector(cgPoint: CGPoint(x:250,y:500)), forKey: "inputTopRight")
  transformFilter?.setValue(CIVector(cgPoint: CGPoint(x:0,y:0)), forKey: "inputBottomLeft")
  transformFilter?.setValue(CIVector(cgPoint: CGPoint(x:250,y:0)), forKey: "inputBottomRight")
  
  let transformed = transformFilter?.outputImage
  let cgOutputImage = context.createCGImage(transformed!, from: inputImage.extent)!
  
  return UIImage(cgImage: cgOutputImage)
}


func perspectiveCorrection(_ input : UIImage, _ bottomLeft : CGPoint, _ bottomRight : CGPoint, _ topRight : CGPoint, _ topLeft : CGPoint) -> UIImage {
  let inputImage = CIImage(image: input)!
  let context = CIContext()
  let transformFilter = CIFilter(name:"CIPerspectiveCorrection")
  transformFilter?.setValue(inputImage, forKey: kCIInputImageKey)
  transformFilter?.setValue(CIVector(cgPoint: topLeft), forKey: "inputTopLeft")
  transformFilter?.setValue(CIVector(cgPoint: topRight), forKey: "inputTopRight")
  transformFilter?.setValue(CIVector(cgPoint: bottomLeft), forKey: "inputBottomLeft")
  transformFilter?.setValue(CIVector(cgPoint: bottomRight), forKey: "inputBottomRight")
  
  let transformed = transformFilter?.outputImage
  let cgOutputImage = context.createCGImage(transformed!, from: inputImage.extent)!
  
  return UIImage(cgImage: cgOutputImage)
}

