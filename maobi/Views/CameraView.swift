import SwiftUI
import UIKit
import AVFoundation


struct CameraView: View {
  var levels : Levels
    @State private var showCameraPicker = false
    @State private var navigateToAlignmentView = false
    @State var opacity = 0.2
    @ObservedObject var cameraModel: CameraModel
    var character: CharacterData

    var body: some View {
      var overlay = UIImageView(image: UIImage(named: "\(character.toString())_template")!)
            VStack {
              Text("Getting Camera Feedback").font(.title)
              Text("After clicking open camera, please take a photo aligned to the overlay. You will receive feedback about the thickness, alignment, and stroke order of the character in this level: \(character.toString()). ").padding()
              
              Button(action: {
                showCameraPicker = true
                overlay.alpha = 0.2
              }) {
                Text("Open Camera")
              }.padding(.all)
                .background(Color(red: 0.83, green: 0.25, blue: 0.17))
                .foregroundColor(.white)
                .cornerRadius(15.0)
              
            }
            .sheet(isPresented: $showCameraPicker) {
              VStack{
                ZStack(alignment: .top) {
                  ImagePicker(character: character.toString(), overlay: overlay, sourceType: .camera) { selectedImage in
                    cameraModel.storeImage(selectedImage) // Store the cropped image in CameraModel
                    cameraModel.overlayImage(character: character)
                    navigateToAlignmentView = true // Trigger navigation
                  }
//                  .overlay(
//                    Image(uiImage: UIImage(named: "\(character.toString())_template")!).opacity(self.opacity)
//                  )
                }
                
//                Button(action: {
//                  let renderer = ImageRenderer(content : self)
//                  if let uiImage = renderer.uiImage {
//                    cameraModel.composedImage = uiImage
//                  } else {
//                    cameraModel.composedImage = UIImage(named: "\(character.toString())_template")!
//                  }
//                  showCameraPicker = false
//                  navigateToAlignmentView = true
//                }) {
//                  Text("Take Picture")
//                }.padding(.all)
//                  .background(Color(red: 0.83, green: 0.25, blue: 0.17))
//                  .foregroundColor(.white)
//                  .cornerRadius(15.0)
                
                
              }
            
        }.navigate(to: AlignPhotoView(character: character.toString(), levels: levels, cameraModel: cameraModel), when: $navigateToAlignmentView)
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
        overlay.frame = overlay.frame.offsetBy(dx: CGFloat(0), dy: CGFloat(150))
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



extension View {
    /// Navigate to a new view.
    /// - Parameters:
    ///   - view: View to navigate to.
    ///   - binding: Only navigates when this condition is `true`.
    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View {
        NavigationView {
            ZStack {
                self
                    .navigationBarHidden(true)

                NavigationLink(
                    destination: view,
                    isActive: binding
                ) {
                    EmptyView()
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
