// Feedback.swift

import WebKit
import SwiftUI
import CoreGraphics
import Combine
import Foundation
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

enum InvalidSubmission: Error {
    case invalid
}

class ProcessImage {
  var submissionPts : [[CGPoint]] = []
  var templatePts : [[CGPoint]] = []
  var templateAnchors : [CGPoint] = []
  var templateAnchorMapping : [[(Int, Int)]] = []
  var alignmentAnchors : [CGPoint] = []
  var strokes : [StrokeContour] = []
  var templateStrokes : [StrokeContour] = []
  var characterContour : CharacterContour
  var invalid = false
  
  var stars : Int = 1
  var overallMsg : String = "Awesome Work!"
  var alignmentMsg : String = "Perfect alignment!"
  var thicknessMsg : String = "Perfect thickness!"
  var strokeorderMsg : String = "TBD"
  var feedback : [Dictionary<String, String>] = []

  init(submission : UIImage, template : UIImage, character : String) {
    self.submissionPts = detectVisionContours(submission).filter { $0.count > 50 }
    self.templatePts = detectVisionContours(template)
    self.submissionPts.sort(by: {$0[0].x < $1[0].x})
    self.templatePts.sort(by: {$0[0].x < $1[0].x})
    self.characterContour = CharacterContour(self.submissionPts)
    
    do {
      try getAnchors(character)
      try joinAnchors(character)
      try calculateFeedback()
    } catch {
      self.invalid = true
      self.stars = 0
      self.overallMsg = "Invalid or misaligned photo. Please retry."
      self.alignmentMsg = ""
      self.thicknessMsg = ""
      self.strokeorderMsg = ""
    }
  }
  
  
  func calculateFeedback() throws {
    var perfectThickness = true
    var perfectAlignment = true
    var delta = 10 // allowed error
    let numStrokes = self.strokes.count
    
    if(numStrokes < 1) {throw InvalidSubmission.invalid}
    for i in 0...(numStrokes-1) {
      var thicknessResult = ""
      var alignmentResult = ""
      let userStroke : UIBezierPath = self.strokes[i].outline
      // Sample every 10th pt
      var templateStrokeSample = self.templateStrokes[i].contourpts
        
      
      // Thickness
      var ct = 0
      for pt in templateStrokeSample {
        ct = userStroke.contains(pt) ? ct+1 : ct-1
      }
      let percentDiff = Float(abs(ct)) / Float(self.strokes[i].contourpts.count)
      if(percentDiff > 0.25) {
        thicknessResult = ct < 0 ? "Too thin." : "Too thick."
        perfectThickness = false
      } else {
        thicknessResult = "Perfect thickness!"
      }
      
      // Alignment
      let subStroke = self.strokes[i]
      let tempStroke = self.templateStrokes[i]
      let (subLeft, subRight) = horizontalExtremes(subStroke)
      let (tempLeft, tempRight) = horizontalExtremes(tempStroke)
      let (subTop, subBottom) = verticalExtremes(subStroke)
      let (tempTop, tempBottom) = verticalExtremes(tempStroke)
      var strokePerfectAlignment = true
      
      if(abs(subLeft - tempLeft) > delta) {
        perfectAlignment = false
        strokePerfectAlignment = false
        alignmentResult += subLeft < tempLeft ? "Leftside too far left. " : "Leftside too far right. "
      }
      
      if(abs(subRight - tempRight) > delta) {
        perfectAlignment = false
        strokePerfectAlignment = false
        alignmentResult += subRight < tempRight ? "Rightside too far left. " : "Rightside too far right. "
      }
      
      if(abs(subTop - tempTop) > delta) {
        perfectAlignment = false
        strokePerfectAlignment = false
        alignmentResult += subTop < tempTop ? "Top too high. " : "Top too low. "
      }
      
      if(abs(subBottom - tempBottom) > delta) {
        perfectAlignment = false
        strokePerfectAlignment = false
        alignmentResult += subBottom < tempBottom ? "Bottom too high. " : "Bottom too low. "
      }
      
      if(strokePerfectAlignment) { alignmentResult = "Perfect alignment!" }
      
      feedback.append(["thickness": thicknessResult, "alignment": alignmentResult, "strokeOrder": "TBD"])
    }
    
    // Adjust overall feedback & stars
    if(perfectAlignment) {
      self.alignmentMsg = "Perfect alignment!"
      self.stars += 1
    } else {
      self.alignmentMsg = "Good start."
    }
    
    if(perfectThickness) {
      self.stars += 1
      self.thicknessMsg = "Perfect thickness!"
    } else {
      self.thicknessMsg = "Good start."
    }
    
    if(perfectAlignment && perfectThickness) {
      self.overallMsg = "Awesome Work!"
    } else if(perfectAlignment || perfectThickness) {
      self.overallMsg = "Good progress."
    } else {
      self.overallMsg = "Try again."
    }
    
    
  }
  
  // Grabs the corresponding template anchors for the char
  func getAnchors(_ character : String) throws {
    if(character == "十") {
      self.templateAnchors = [(110, 112), (110, 100), (126, 98), (125, 112)]
        .map {CGPoint(x:$0.0, y:$0.1)}
      self.templateAnchorMapping = [[(1,2),(3,0)], [(0,1),(2,3)]]
      self.alignmentAnchors = [(123,18), (125, 231),(84, 201), (28,145),(64,99),(173,96),(223,146)].map {CGPoint(x:$0.0, y:$0.1)}
    } else if (character == "小") {
      self.alignmentAnchors = [(114,400-18), (129, 400-233), (79, 400-197), (60,400-102),(29,400-158),(173,400-92),(223,400-148)].map {CGPoint(x:$0.0, y:$0.1)}
      print("No joints")
    } else {
      print("No joints")
    }
  }
  
  // Interprets the templateAnchorMapping and creates stroke objects
  func joinAnchors(_ character : String) throws {
    if(character == "小" || character == "八" || character == "二" || ["一", "丨", " ` ", "亅", "丶", "丿", "ノ"].contains(character)) {
      for stroke in self.submissionPts {
        self.strokes.append(StrokeContour(stroke))
      }
      for stroke in self.templatePts {
        self.templateStrokes.append(StrokeContour(stroke))
      }
    } else {
      var anchorPts : [(Int, CGPoint)] = []
      if(self.submissionPts.count < 1) { throw InvalidSubmission.invalid }
      let submissionPts = self.submissionPts[0]
      for pt in self.templateAnchors {
        anchorPts.append(closestPoint(CGPoint(x:pt.x, y:pt.y), submissionPts))
      }
      
      let n = submissionPts.count-1
      
      for stroke in self.templateAnchorMapping {
        var strokePts : [CGPoint] = []
        
        for (s,d) in stroke {
          if(s >= anchorPts.count || d >= anchorPts.count) { throw InvalidSubmission.invalid }
          let (sidx, _) = anchorPts[s]
          let (eidx, _) = anchorPts[d]
          if(sidx >= submissionPts.count || eidx >= submissionPts.count) { throw InvalidSubmission.invalid }
          if(sidx > eidx) {
            strokePts += (submissionPts[sidx...n] + submissionPts[0...eidx])
          } else {
            strokePts += submissionPts[sidx...eidx]
          }
        }
        let sample = strokePts.enumerated().compactMap { i, e in i % 5 == 0 ? e : nil }
        if(sample.count < 2) { throw InvalidSubmission.invalid }
        let newStrokeObject = StrokeContour(sample)
        self.strokes.append(newStrokeObject)
      }
    }
    if(self.strokes.count != self.templateStrokes.count) {
      throw InvalidSubmission.invalid
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
  
  // Returns leftmost and rightmost anchor points in a stroke
  func horizontalExtremes(_ stroke : StrokeContour) -> (Int, Int) {
    let sorted = stroke.contourpts.sorted(by: { $0.x < $1.x })
    let left = Int(sorted[0].x)
    let right = Int(sorted[sorted.count-1].x)
    return (left, right)
  }
  // Returns lowest and highest anchor points in a stroke
  func verticalExtremes(_ stroke : StrokeContour) -> (Int, Int) {
    let sorted = stroke.contourpts.sorted(by: { $0.y < $1.y })
    let lowest = Int(sorted[0].y)
    let highest = Int(sorted[sorted.count-1].y)
    return (lowest, highest)
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
  var outline = UIBezierPath()
  
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
  
  func makeOutline() {
    for stroke in cgpts {
      self.outline.move(to: stroke[0])
      for pt in stroke {
        self.outline.addLine(to: pt)
      }
    }
  }
}

