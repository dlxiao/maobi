import CoreGraphics
import Vision
import UIKit
import CoreImage


// Get contours from image
// Code for applying VNImageRequest is modified from
// iOS14VisionContourDetection (GitHub) by Anupam Chugh on 26/06/20

func detectVisionContours(_ srcimg: UIImage) -> [[CGPoint]] {
  
    let context = CIContext()
    var inputImage = CIImage.init(cgImage: srcimg.cgImage!)
    let contourRequest = VNDetectContoursRequest.init()
    contourRequest.revision = VNDetectContourRequestRevision1
    contourRequest.contrastAdjustment = 1.0
    contourRequest.maximumImageDimension = 512
    
    do {
      let noiseReductionFilter = CIFilter.gaussianBlur()
      noiseReductionFilter.radius = 0.5
      noiseReductionFilter.inputImage = inputImage
      
      let blackAndWhite = CustomFilter()
      blackAndWhite.inputImage = noiseReductionFilter.outputImage!
      inputImage = blackAndWhite.outputImage!
    }
    
    let requestHandler = VNImageRequestHandler.init(ciImage: inputImage, options: [:])
    
    try! requestHandler.perform([contourRequest])
    let contoursObservation = contourRequest.results?.first as! VNContoursObservation
    
    
    do {
      let numContours = contoursObservation.contourCount
      var pts : [[CGPoint]] = []
      if(numContours < 2) { throw InvalidSubmission.invalid }
      for contourIdx in 1...(numContours-1) {
        let contour = try contoursObservation.contour(at:contourIdx)
        pts.append(contour.normalizedPoints.map { CGPoint(x:Int($0[0]*250.0), y:Int((1-$0[1])*250.0))})
      }
      return pts
    } catch {
      print("Error getting contour")
    }
  
  return []
}

class CustomFilter: CIFilter {
  var inputImage: CIImage?
  
  override public var outputImage: CIImage! {
    get {
      if let inputImage = self.inputImage {
        let args = [inputImage as AnyObject]
        
        let callback: CIKernelROICallback = {
          (index, rect) in
          return rect.insetBy(dx: -1, dy: -1)
        }
        
        return createCustomKernel().apply(extent: inputImage.extent, roiCallback: callback, arguments: args)
      } else {
        return nil
      }
    }
  }
  
  func createCustomKernel() -> CIKernel {
    return CIColorKernel(source:
                          "kernel vec4 replaceWithBlackOrWhite(__sample s) {" +
                         "if (s.r > 0.25 && s.g > 0.25 && s.b > 0.25) {" +
                         "    return vec4(0.0,0.0,0.0,1.0);" +
                         "} else {" +
                         "    return vec4(1.0,1.0,1.0,1.0);" +
                         "}" +
                         "}"
    )!
    
  }
}


