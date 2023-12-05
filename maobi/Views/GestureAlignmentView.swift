import SwiftUI
import UIKit

struct GestureAlignmentView: View {
    @EnvironmentObject var opData : OpData
    @State private var offset: CGSize = .zero
    @State private var zoom: CGFloat = 1
    @State private var angle: Angle = Angle(degrees: 0)
    @State private var showTransformedImage = false

    var body: some View {
        VStack {
            ZStack {
              if let baseImage = opData.cameraModel.originalImage {
                  Image(uiImage: baseImage)
                      .resizable()
                      .frame(width: 400, height: 400)
                      .scaleEffect(zoom)
                      .offset(offset)
                      .rotationEffect(angle)
              }
              if let character = opData.character,
                 let overlayImage = UIImage(named: "\(character.toString())_template") {
                  Image(uiImage: overlayImage)
                      .resizable()
                      .frame(width: 400, height: 400)
                      .opacity(0.5)
              }
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
                showTransformedImage = true
                if let transformedImage = opData.cameraModel.transformedImage {
                  opData.lastView.append(opData.currView)
                  opData.currView = .feedback
                }
             }
        }
        .sheet(isPresented: $showTransformedImage) {
          if let transformedImage = opData.cameraModel.transformedImage {
              Image(uiImage: transformedImage)
                  .resizable()
                  .scaledToFit()
          } else {
              Text("No image saved")
          }
        }
    }
  private func saveTransformedImage() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      let size = CGSize(width: 400, height: 400)
      let renderer = UIGraphicsImageRenderer(size: size)

      let image = renderer.image { _ in
          let rootView = ZStack {
            if let baseImage = opData.cameraModel.originalImage {
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
          hostingController.view.setNeedsLayout()
          hostingController.view.layoutIfNeeded()

          // Render the view hierarchy into the image context
          hostingController.view.drawHierarchy(in: hostingController.view.bounds, afterScreenUpdates: true)
      }
      print("Image rendering completed") // 打印图像渲染完成的标记
          opData.cameraModel.storeTransformedImage(image)
          
      }
  }


}
