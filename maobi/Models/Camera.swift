// Camera model
import CoreImage
import SwiftUI
import Foundation
import Combine

class CameraModel: ObservableObject {
    @Published var originalImage: UIImage?
    @Published var transformedImage: UIImage?
    func storeOrigImage(_ newImage: UIImage) {
        originalImage = newImage
    }
    func storeTransformedImage(_ newImage: UIImage) {
        transformedImage = newImage
    }
}
