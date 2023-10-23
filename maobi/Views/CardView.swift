import Foundation
import SwiftUI
import WebKit
import CoreImage
import UIKit


let context = CIContext()
let imageURL = URL(fileURLWithPath: "\(Bundle.main.bundlePath)/sampleUserImg.png")
let originalCIImage = CIImage(contentsOf: imageURL)!
let testUIImage = UIImage(ciImage:originalCIImage)
let imageView = UIImageView(image: testUIImage)

struct CardView: View {
  var body: some View {
    VStack{
      Text("Test image")
      Image("sampleUserImg")
      // displaying image worked only after adding image to Assets
    }
      
    
  }
}



