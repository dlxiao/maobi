//
//  AlignmentView.swift
//  maobi
//
//  Created by Lucy on 11/8/23.
//

import SwiftUI

struct AlignmentView: View {
    @ObservedObject var cameraModel: CameraModel
//    @Binding var image: UIImage?
    var character: CharacterData // pass this to get the overlay image
    @State private var navigateToFeedback = false
    var body: some View {
        VStack {
            if let composedImage = cameraModel.composedImage {
                Image(uiImage: composedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Button(action: {}) {
                  NavigationLink(
                    destination: FeedbackView(feedback: cameraModel.getFeedback(character,composedImage)),
                    label: { Text("Submit Photo").fontWeight(.bold)
                    })
              }.padding(.all)
                .background(Color(red: 0.83, green: 0.25, blue: 0.17))
                .foregroundColor(.white)
                .cornerRadius(15.0)
            } else {
                Text("No composed image available")
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            // Overlay the hardcoded image when the view appears
            cameraModel.overlayImage(character: character)
        }
    }
}
