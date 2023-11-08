import CoreImage
import SwiftUI
import Foundation
import Combine

class CameraModel: ObservableObject {
    @Published var image: UIImage?
    @Published var composedImage: UIImage?
    @Published var feedback: [String: String]?
    
    //TODO: save to firebase after user login finished
    func storeImage(_ newImage: UIImage) {
        image = newImage
    }

    // TODO
//    func getOverlay(_ character : String) -> Image {
//      return
//    }
    func overlayImage(character: CharacterData) {
        guard let baseImage = image else {
            return
        }

        guard let overlayImage = UIImage(named: "ten") else {
            print("Failed to load the overlay image from assets.")
            return
        }

        let newSize = CGSize(width: baseImage.size.width, height: baseImage.size.height)
        let fixedSize = CGSize(width: 250, height: 250)

        UIGraphicsBeginImageContextWithOptions(newSize, false, baseImage.scale)

        baseImage.draw(in: CGRect(origin: .zero, size: newSize))
        overlayImage.draw(in: CGRect(origin: .zero, size: newSize), blendMode: .normal, alpha: 0.5)

        let newComposedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // Resize the newComposedImage to fixed size (250x250)
        UIGraphicsBeginImageContextWithOptions(fixedSize, false, 1.0) // scale of 1.0 for fixed pixel size
        newComposedImage?.draw(in: CGRect(origin: .zero, size: fixedSize))

        let resizedComposedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        composedImage = resizedComposedImage
    }

  
    // Add more functions as needed to manipulate the image

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
}
