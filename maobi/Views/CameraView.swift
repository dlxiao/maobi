import SwiftUI
import UIKit
import AVFoundation

extension UIImage {
    
    // Crop the image to a specified ratio by removing the excess parts.
    func crop(ratio: CGFloat) -> UIImage {
        var newSize: CGSize!
        if size.width / size.height > ratio {
            newSize = CGSize(width: size.height * ratio, height: size.height)
        } else {
            newSize = CGSize(width: size.width, height: size.width / ratio)
        }
        
        let rect = CGRect(
            x: (newSize.width - size.width) / 2.0,
            y: (newSize.height - size.height) / 2.0,
            width: size.width,
            height: size.height
        )
        
        UIGraphicsBeginImageContext(newSize)
        draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage ?? self
    }
}

struct CameraView: View {
  var levels : Levels
    @State private var showCameraPicker = false
    @State private var navigateToAlignmentView = false
    @ObservedObject var cameraModel: CameraModel
    var character: CharacterData

    var body: some View {
            VStack {
              Text("Getting Camera Feedback").font(.title)
              Text("After clicking open camera, please take a photo aligned to the overlay. You will receive feedback about the thickness, alignment, and stroke order of the character in this level: \(character.toString()). ").padding()
              
              Button(action: {showCameraPicker = true}) {
                Text("Open Camera")
              }.padding(.all)
                .background(Color(red: 0.83, green: 0.25, blue: 0.17))
                .foregroundColor(.white)
                .cornerRadius(15.0)
              
              // NavigationLink that is activated when `navigateToAlignmentView` is true
              NavigationLink(
                destination: AlignPhotoView(character: character.toString(), levels: levels, cameraModel: cameraModel),
                  isActive: $navigateToAlignmentView,
                  label: {
                      EmptyView()
                  })
            }
            .sheet(isPresented: $showCameraPicker) {
              ZStack(alignment: .top) {
                ImagePicker(character: character.toString(), sourceType: .camera) { selectedImage in
                    cameraModel.storeImage(selectedImage) // Store the cropped image in CameraModel
                    cameraModel.overlayImage(character: character)
                    navigateToAlignmentView = true // Trigger navigation
                }.overlay(
                  Image(uiImage: UIImage(named: "\(character.toString())_template")!).opacity(0.2)
                )
                
                
              }
                
            }

        .onChange(of: cameraModel.image) { _ in
            navigateToAlignmentView = true // Navigate when the image is set in CameraModel
        }
    }
}


struct ImagePicker: UIViewControllerRepresentable {
  var character: String
    @Environment(\.presentationMode) private var presentationMode
    let sourceType: UIImagePickerController.SourceType
    let onImagePicked: (UIImage) -> Void
 
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
      var character : String
        @Binding private var presentationMode: PresentationMode
        private let sourceType: UIImagePickerController.SourceType
        private let onImagePicked: (UIImage) -> Void
 
      init(character: String, presentationMode: Binding<PresentationMode>,
             sourceType: UIImagePickerController.SourceType,
             onImagePicked: @escaping (UIImage) -> Void) {
        self.character = character
            _presentationMode = presentationMode
            self.sourceType = sourceType
            self.onImagePicked = onImagePicked
          
        }
 
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                // Crop the image to a square before passing it back
                let croppedImage = uiImage.crop(ratio: 1)
                onImagePicked(croppedImage)
            }
            presentationMode.dismiss()
        }
 
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }
 
    }
 
    func makeCoordinator() -> Coordinator {
      return Coordinator(character: character,
                          presentationMode: presentationMode,
                           sourceType: sourceType,
                           onImagePicked: onImagePicked)
    }
 
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
 
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
}
