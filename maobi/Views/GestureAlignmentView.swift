import SwiftUI
import UIKit

struct GestureAlignmentView: View {
    @EnvironmentObject var opData : OpData
    @State private var offset: CGSize = .zero
    @State private var zoom: CGFloat = 1
    @State private var angle: Angle = Angle(degrees: 0)
    @State private var showSavedImage = false
    @State private var savedImage: UIImage?
//    var baseImage: UIImage
//    var overlayImage: UIImage

    var body: some View {
        VStack {
            ZStack {
              if let baseImage = opData.cameraModel.image {
                  Image(uiImage: baseImage)
                      .resizable()
                      .frame(width: 400, height: 400)
                      .scaleEffect(zoom)
                      .offset(offset)
                      .rotationEffect(angle)
              }
//                Image("小_offset")
//                    .resizable()
//                    .frame(width: 400, height: 400)
              if let character = opData.character,
                 let overlayImage = UIImage(named: "\(character.toString())_template") {
                  Image(uiImage: overlayImage)
                      .resizable()
                      .frame(width: 400, height: 400)
                      .opacity(0.5)
              }
//                Image("小_template")
//                    .resizable()
//                    .frame(width: 400, height: 400)
//                    .opacity(0.5)
            }
            .frame(width: 400, height: 400)
            .border(Color.black)
            .background(Color.white)
            .simultaneousGesture(MagnificationGesture().onChanged { z in
                let newZoom = zoom + (z > 1 ? 0.05 : -0.05)
                zoom = max(newZoom, 1) // make sure zoom in only
            })
            .simultaneousGesture(DragGesture().onChanged { value in
                offset = value.translation
            })
            .simultaneousGesture(RotationGesture().onChanged { a in
                angle = a
            })

            Button("Save Image") {
                saveTransformedImage()
//              opData.lastView.append(opData.currView)
//              opData.currView = .feedback
             }
        }
        .sheet(isPresented: $showSavedImage) {
            if let savedImage = savedImage {
                Image(uiImage: savedImage)
                    .resizable()
                    .scaledToFit()
                    .offset(y: -20)
            } else {
                Text("No image saved")
            }
        }
    }
  private func saveTransformedImage() {
      let size = CGSize(width: 400, height: 400)
      let renderer = UIGraphicsImageRenderer(size: size)

      let image = renderer.image { _ in
          let rootView = ZStack {
            if let baseImage = opData.cameraModel.image {
                Image(uiImage: baseImage)
                    .resizable()
                    .frame(width: 400, height: 400)
                    .scaleEffect(zoom)
                    .offset(offset)
                    .rotationEffect(angle)
            }

//            if let character = opData.character,
//               let overlayImage = UIImage(named: "\(character.toString())_template") {
//                Image(uiImage: overlayImage)
//                    .resizable()
//                    .frame(width: 400, height: 400)
//                    .opacity(0.5)
//            }
          }
          .background(Color.white)
          .edgesIgnoringSafeArea(.all)

          let hostingController = UIHostingController(rootView: rootView)
          hostingController.view.frame = CGRect(origin: .zero, size: size)
          hostingController.view.backgroundColor = UIColor.clear

          // This will lay out the subviews immediately
          hostingController.view.layoutIfNeeded()

          // Render the view hierarchy into the image context
          hostingController.view.drawHierarchy(in: hostingController.view.bounds, afterScreenUpdates: true)
      }

      DispatchQueue.main.async {
          self.savedImage = image
//          opData.cameraModel.storeImage(image)
          self.showSavedImage = true
      }
  }


}