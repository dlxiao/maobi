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
  var alignmentAnchors : [CGPoint] = []
  var strokes : [StrokeContour] = []
  var templateStrokes : [StrokeContour] = []
  var characterContour : CharacterContour
  
  var stars : Int = 1
  var overallMsg : String = "Awesome work!"
  var alignmentMsg : String = "Perfect alignment."
  var thicknessMsg : String = "Perfect thickness."
  var strokeorderMsg : String = "TBD"
  var feedback : [Dictionary<String, String>] = []
  
  
  init(submissionPath : String, templatePath : String, character : String) {
    self.submissionPts = detectVisionContours(submissionPath)
    self.templatePts = detectVisionContours(templatePath)
    self.submissionPts.sort(by: {$0[0].x < $1[0].x})
    self.templatePts.sort(by: {$0[0].x < $1[0].x})
    self.characterContour = CharacterContour(self.submissionPts)
    getAnchors(character)
    joinAnchors(character)
    calculateFeedback()
  }
  
  
  func calculateFeedback() {
    var perfectThickness = true
    var perfectAlignment = true
    var delta = 5
    let numStrokes = self.strokes.count
    
    for i in 0...(numStrokes-1) {
      var thicknessResult = ""
      var alignmentResult = ""
      let userStroke : UIBezierPath = self.strokes[i].outline
      // Sample every 10th pt
      var templateStrokeSample = self.templateStrokes[i].contourpts
        
      var ct = 0
      
      // for a sample of pts in templateStroke, check if inside or outside user
      for pt in templateStrokeSample {
        ct = userStroke.contains(pt) ? ct+1 : ct-1
      }
      let percentDiff = Float(abs(ct)) / Float(self.strokes[i].contourpts.count / 10)

      if(percentDiff > 0.6) {
        thicknessResult = ct < 0 ? "Too thin." : "Too thick."
        perfectThickness = false
      } else {
        thicknessResult = "Perfect thickness!"
      }
      
      var horizontalAlign = 0
      var verticalAlign = 0
      let anchorCt = self.alignmentAnchors.count
      for pt in self.alignmentAnchors {
        let subPt = closestPoint(pt, self.submissionPts.flatMap {$0})
        let tempPt = closestPoint(pt, self.templatePts.flatMap {$0})
        horizontalAlign = subPt.1.x < tempPt.1.x ? horizontalAlign - 1 : horizontalAlign + 1
        verticalAlign = subPt.1.y < tempPt.1.y ? verticalAlign - 1 : verticalAlign + 1
      }
      print("\(horizontalAlign), \(verticalAlign)")
      
      if(abs(horizontalAlign) > anchorCt / 2) {
        perfectAlignment = false
        alignmentResult += horizontalAlign > 0 ? "Too high. " : "Too low. "
      }
      
      if(abs(verticalAlign) > anchorCt / 2) {
        perfectAlignment = false
        alignmentResult += verticalAlign > 0 ? "Too much to the right. " : "Too much to the left. "
      } else {
        alignmentResult = "Perfect alignment!"
      }
      
      feedback.append(["thickness": thicknessResult, "alignment": alignmentResult, "strokeOrder": "TBD"])
    
      if(alignmentResult == "Perfect alignment!" && thicknessResult == "Perfect thickness!") {
        self.stars = 3
        self.overallMsg = "Awesome Work!"
      } else if(alignmentResult == "Perfect alignment!" || thicknessResult == "Perfect thickness!") {
        self.stars = 2
        self.overallMsg = "Good progress."
      } else {
        self.stars = 1
        self.overallMsg = "Try again."
      }
    }
    
    // Adjust overall feedback
    if(perfectAlignment) {
      self.alignmentMsg = "Perfect alignment!"
    } else {
      self.alignmentMsg = "Good start."
    }
    if(perfectThickness) {
      self.thicknessMsg = "Perfect thickness!"
    } else {
      self.thicknessMsg = "Good start."
    }
  }
  
  // Grabs the corresponding template anchors for the char
  func getAnchors(_ character : String) {
    if(character == "十") {
      self.templateAnchors = [(110, 112), (110, 100), (126, 98), (125, 112)]
        .map {CGPoint(x:$0.0, y:$0.1)}
      self.templateAnchorMapping = [[(1,2),(3,0)], [(0,1),(2,3)]]
      self.alignmentAnchors = [(123,18), (125, 231),(84, 201), (28,145),(64,99),(173,96),(223,146)].map {CGPoint(x:$0.0, y:$0.1)}
    } else if(character == "九") {
      print("")
    } else if (character == "小") {
      print("No joints")
    } else if (character == "八") {
      print("No joints")
    } else if (character == "七") {
      print("")
    } else {
      print("Error: character not in dataset")
    }
  }
  
  // Interprets the templateAnchorMapping and creates stroke objects
  func joinAnchors(_ character : String) {
    var anchorPts : [(Int, CGPoint)] = []
    if(character == "小") {
      
      for stroke in self.submissionPts {
        self.strokes.append(StrokeContour(stroke))
      }
      for stroke in self.templatePts {
        self.templateStrokes.append(StrokeContour(stroke))
      }
    } else {
      let submissionPts = self.submissionPts[0]
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

