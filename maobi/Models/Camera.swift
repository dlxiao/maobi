// This file contains camera feature stuff

import CoreImage
import SwiftUI
import Foundation

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
