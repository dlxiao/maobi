// Feedback.swift



import WebKit
import SwiftUI
import CoreGraphics
import Combine
import Foundation
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins



class ProcessImage {
  var submissionPts : [[CGPoint]] = []
  var templatePts : [[CGPoint]] = []
  var templateAnchors : [CGPoint] = []
  var templateAnchorMapping : [[(Int, Int)]] = []
  var strokes : [StrokeContour] = []
  var characterContour : CharacterContour
  
  init(submissionPath : String, templatePath : String, character : String) {
    self.submissionPts = detectVisionContours(submissionPath)
    self.templatePts = detectVisionContours(templatePath)
    self.characterContour = CharacterContour(self.submissionPts)
    getTemplateAnchors(character)
    joinAnchors()
  }
  
  // Grabs the corresponding template anchors for the char
  func getTemplateAnchors(_ character : String) {
    if(character == "十") {
      self.templateAnchors = [(110, 112), (110, 100), (126, 98), (125, 112)]
        .map {CGPoint(x:$0.0, y:$0.1)}
      self.templateAnchorMapping = [[(1,2),(3,0)], [(0,1),(2,3)]]
    } else if(character == "九") {
      print("")
    } else if (character == "小") {
      print("")
    } else if (character == "王") {
      print("")
    } else if (character == "七") {
      print("")
    } else {
      print("Error: character not in dataset")
    }
  }
  
  // Interprets the templateAnchorMapping and creates stroke objects
  func joinAnchors() {
    let submissionPts = self.submissionPts[0]
    var anchorPts : [(Int, CGPoint)] = []
    for pt in self.templateAnchors {
      anchorPts.append(closestPoint(CGPoint(x:pt.x, y:pt.y), submissionPts))
    }
    
    let n = submissionPts.count-1
    
    for stroke in self.templateAnchorMapping {
      var strokePts : [CGPoint] = []
      
      for (s,d) in stroke {
        let (sidx, _) = anchorPts[s]
        let (eidx, _) = anchorPts[d]
        if(sidx > eidx) {
          strokePts += (submissionPts[sidx...n] + submissionPts[0...eidx])
        } else {
          strokePts += submissionPts[sidx...eidx]
        }
      }
      let sample = strokePts.enumerated().compactMap { i, e in i % 5 == 0 ? e : nil }
      let newStrokeObject = StrokeContour(sample)
      self.strokes.append(newStrokeObject)
    }
  }
  
  // Helpers for euclidean distance from https://www.hackingwithswift.com/example-code/core-graphics/how-to-calculate-the-distance-between-two-cgpoints
  func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
    return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
  }
  
  func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
    return sqrt(CGPointDistanceSquared(from: from, to: to))
  }
  
  // Helper to find closest submission point to target
  func closestPoint(_ target : CGPoint, _ submissionPts : [CGPoint]) -> (Int, CGPoint) {
    let dists = (submissionPts.map { CGPointDistance(from: $0, to: target) }).enumerated()
    let closest = dists.min(by: { $0.1 < $1.1 }) ?? (0, 0)
    return (closest.0, submissionPts[closest.0])
  }
  
  // Given location of click, return which shape was clicked or -1 if invalid
  func shapeClicked(_ pt : CGPoint) -> Int {
    for i in 0...(self.strokes.count-1) {
      if ((self.strokes[i]).outline.contains(pt)) {
        return i
      }
    }
    return -1
  }
  
}


// Stroke Shape Object - draws a single stroke given its points
// Created automatically per stroke by ProcessImage object
struct StrokeContour: Shape {
  var contourpts : [CGPoint] = []
  var outline = UIBezierPath()
  
  init (_ allpts: [CGPoint]) {
    self.contourpts = allpts
    makeOutline()
  }
  
  func path(in rect: CGRect) -> Path {
    Path { path in
      path.move(to: contourpts[0])
      for pt in contourpts {
        path.addLine(to: pt)
      }
      path.closeSubpath()
    }
  }
  
  func makeOutline() {
    self.outline.move(to: self.contourpts[0])
    for pt in self.contourpts {
      self.outline.addLine(to: pt)
    }
  }
  
}


// Character Shape Object - draws the whole character given its pts
struct CharacterContour: Shape {
  var cgpts : [[CGPoint]] = []
  
  init(_ pts : [[CGPoint]]) {
    self.cgpts = pts
  }
  
  func path(in rect: CGRect) -> Path {
    Path { path in
      for stroke in cgpts {
        path.move(to: stroke[0])
        for pt in stroke {
          path.addLine(to: pt)
        }
      }
      path.closeSubpath()
    }
  }
}



// Get contours from image
// Code for applying VNImageRequest is modified from
// iOS14VisionContourDetection (GitHub) by Anupam Chugh on 26/06/20

func detectVisionContours(_ path: String) -> [[CGPoint]] {
  
  let context = CIContext()
  if let sourceImage = UIImage.init(named: path) {
    var inputImage = CIImage.init(cgImage: sourceImage.cgImage!)
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
      for contourIdx in 1...(numContours-1) {
        let contour = try contoursObservation.contour(at:contourIdx)
        pts.append(contour.normalizedPoints.map { CGPoint(x:Int($0[0]*250.0), y:Int((1-$0[1])*250.0))})
      }
      return pts
    } catch {
      print("Error getting contour")
    }
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
