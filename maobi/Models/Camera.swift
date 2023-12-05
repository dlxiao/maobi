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
      
      guard let overlayImage = UIImage(named: "\(character.toString())_template") else {
            print("Failed to load the overlay image from assets.")
            return
        }

        let newSize = CGSize(width: baseImage.size.width, height: baseImage.size.height)
        let fixedSize = CGSize(width: 400, height: 400)

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
}
