import SwiftUI
import UIKit


struct CameraView: View {
    @EnvironmentObject var opData : OpData
    @State private var showCameraPicker = false
//    @State var opacity = 0.2

    var body: some View {
        let characterString = opData.character?.toString() ?? "default_character"
        let filename = "\(characterString)_template"
        // Safely unwrap the UIImage, provide a default image if nil
        let overlayImage = UIImage(named: filename) ?? UIImage() // Default image if nil
        var overlay = UIImageView(image: resizeImage(image: overlayImage, newWidth: 400))
            VStack {
              HStack {
                  Button(action: {
                      opData.currView = opData.lastView.removeLast()
                  }) {
                      HStack {
                          Image(systemName: "chevron.left")
                          Text("Back")
                      }
                      .foregroundColor(.black)
                      .font(.title3)
                      .fontWeight(.bold)
                  }
                  .frame(maxWidth: .infinity, alignment: .leading)
              }
              .padding()
              
              Text("Getting Camera Feedback").font(.title).padding(.top)
              Text("After clicking open camera, please take a photo aligned to the overlay.").padding()
              Image("camerademo")
                .resizable()
                .aspectRatio(contentMode: .fit)
              Text("You will receive feedback about the thickness, alignment, and stroke order of the character in this level: \(characterString). ").padding()
              Spacer()
              Button(action: {
                showCameraPicker = true
                overlay.alpha = 0.2
              }) {
                Text("Open Camera")
              }.padding(.all)
                .background(Color(red: 0.83, green: 0.25, blue: 0.17))
                .foregroundColor(.white)
                .cornerRadius(15.0)
              Spacer()

            }
            .sheet(isPresented: $showCameraPicker) {
              VStack{
                ZStack(alignment: .top) {
                  ImagePicker(character: characterString, overlay: overlay, sourceType: .camera) { selectedImage in
                      opData.cameraModel.storeOrigImage(selectedImage) // Store the cropped image in CameraModel
//                      if let character = opData.character {
//                          opData.cameraModel.overlayImage(character: character)
//                      }
                    opData.lastView.append(opData.currView)
                    opData.currView = .alignment
                  }
//                  .overlay(
//                    Image(uiImage: UIImage(named: "\(character.toString())_template")!).opacity(self.opacity)
//                  )
                }
              }
            }
    }
}

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


struct ImagePicker: UIViewControllerRepresentable {
    var character: String
    var overlay : UIImageView
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
        overlay.frame = CGRect(x: 0, y: 150, width: overlay.frame.width, height: overlay.frame.height)
        picker.cameraOverlayView = overlay


//        picker.showsCameraControls = false;

        NotificationCenter.default.addObserver(forName: NSNotification.Name("_UIImagePickerControllerUserDidCaptureItem"), object: nil, queue: nil) { _ in
            picker.cameraOverlayView = nil
        }

      NotificationCenter.default.addObserver(forName: NSNotification.Name("_UIImagePickerControllerUserDidRejectItem"), object: nil, queue: nil) { _ in picker.cameraOverlayView = overlay }

      return picker

    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
}
