//
//  CameraView.swift
//  maobi
//
//  Created by Dora Xiao on 11/1/23.
//

import SwiftUI

struct CameraView: View {
  @State private var image = UIImage()
  var character : CharacterData
  var levels : Levels
  @State private var showSheet = true
  
  
  var body: some View {
      ImagePicker(sourceType: .camera, selectedImage: self.$image)
      
    Button(action: {}) {
      NavigationLink(
        destination: FeedbackView(feedback: getFeedback(character, image), levels: levels),
        label: { Text("Submit Photo").fontWeight(.bold)
        })
    }.padding(.all)
      .background(Color(red: 0.83, green: 0.25, blue: 0.17))
      .foregroundColor(.white)
      .cornerRadius(15.0)
  }
  
}






import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator

        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

    }
}
