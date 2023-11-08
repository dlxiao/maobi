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
    @State private var showCameraPicker = false
    @State private var navigateToAlignmentView = false
    @ObservedObject var cameraModel: CameraModel
    var character: CharacterData

    var body: some View {
        NavigationView {
            List {
                Button(action: {
                    showCameraPicker = true
                }, label: {
                    Text("Camera")
                })
                
                // NavigationLink that is activated when `navigateToAlignmentView` is true
                NavigationLink(
                  destination: AlignmentView(cameraModel: cameraModel, character: character), // Pass the image as a binding
                    isActive: $navigateToAlignmentView,
                    label: {
                        EmptyView()
                    })
            }
            .sheet(isPresented: $showCameraPicker) {
                ImagePicker(sourceType: .camera) { selectedImage in
                    // Crop the image to a square first
                    // let squareImage = cropToBounds(image: selectedImage)
                    // cameraModel.storeImage(squareImage) // Store the cropped image in CameraModel
                    cameraModel.storeImage(selectedImage) // Store the cropped image in CameraModel
                    cameraModel.overlayImage(character: character)
                    navigateToAlignmentView = true // Trigger navigation
                }
            }
        }
        .onChange(of: cameraModel.image) { _ in
            navigateToAlignmentView = true // Navigate when the image is set in CameraModel
        }
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    let sourceType: UIImagePickerController.SourceType
    let onImagePicked: (UIImage) -> Void
 
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
 
        @Binding private var presentationMode: PresentationMode
        private let sourceType: UIImagePickerController.SourceType
        private let onImagePicked: (UIImage) -> Void
 
        init(presentationMode: Binding<PresentationMode>,
             sourceType: UIImagePickerController.SourceType,
             onImagePicked: @escaping (UIImage) -> Void) {
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
        return Coordinator(presentationMode: presentationMode,
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

//struct CameraView: View {
//    @State private var showCameraPicker = false
//    @State private var image: UIImage?
//    @State private var navigateToAlignmentView = false
//    var character: CharacterData
//
//    var body: some View {
//        NavigationView {
//            List {
//                Button(action: {
//                    showCameraPicker = true
//                }, label: {
//                    Text("Camera")
//                })
//                
//                // NavigationLink that is activated when `navigateToAlignmentView` is true
//                NavigationLink(
//                    destination: AlignmentView(image: image ?? UIImage()),
//                    isActive: $navigateToAlignmentView,
//                    label: {
//                        EmptyView()
//                    })
//            }
//            .sheet(isPresented: $showCameraPicker,
//                   content: {
//                ImagePicker(sourceType: .camera) { selectedImage in
//                    self.image = selectedImage
//                    self.navigateToAlignmentView = true // Trigger navigation
//                }
//            })
//        }
//    }
//}


//import SwiftUI
//
//struct CameraView: View {
//    @State private var image: UIImage?
//    @State private var showSheet = true // set to true to show the camera immediately
//    var character: CharacterData
//
//    var body: some View {
//        VStack {
//            if let image = image {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFit()
//            }
//        }
//        .onAppear {
//            self.showSheet = true // present the camera when the view appears
//        }
//        .sheet(isPresented: $showSheet) {
//            ImagePicker(sourceType: .camera, selectedImage: self.$image)
//        }
//    }
//}
//
//
//struct ImagePicker: UIViewControllerRepresentable {
//    @Environment(\.presentationMode) private var presentationMode
//    var sourceType: UIImagePickerController.SourceType = .camera
//    @Binding var selectedImage: UIImage?
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
//
//        let imagePicker = UIImagePickerController()
//        imagePicker.allowsEditing = false
//        imagePicker.sourceType = sourceType
//        imagePicker.delegate = context.coordinator
//
//        return imagePicker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
//
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//        var parent: ImagePicker
//
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//                parent.selectedImage = image
//            }
//
//            parent.presentationMode.wrappedValue.dismiss()
//        }
//
//    }
//}

//
//struct CameraView: View {
//  @State private var image = UIImage()
//  var character : CharacterData
//  @State private var showSheet = true
//  
//  
//  var body: some View {
//      ImagePicker(sourceType: .camera, selectedImage: self.$image)
//      
//    Button(action: {}) {
//      NavigationLink(
//        destination: FeedbackView(feedback: getFeedback(character, image)),
//        label: { Text("Submit Photo").fontWeight(.bold)
//        })
//    }.padding(.all)
//      .background(Color(red: 0.83, green: 0.25, blue: 0.17))
//      .foregroundColor(.white)
//      .cornerRadius(15.0)
//  }
//  
//}
