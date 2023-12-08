import SwiftUI
import UIKit

struct GestureAlignmentView: View {
  @EnvironmentObject var opData : OpData
  @State private var offset: CGSize = .zero
  @State private var zoom: CGFloat = 1
  @State private var angle: Angle = Angle(degrees: 0)
  @State private var finalOffset: CGSize = .zero
  @State private var finalZoom: CGFloat = 1
  @State private var finalAngle: Angle = Angle(degrees: 0)
  @State private var showTransformedImage = false
  
  var magnificationGesture: some Gesture {
    MagnificationGesture()
      .onChanged { value in
        zoom = finalZoom * value
      }
      .onEnded { value in
        finalZoom *= value
      }
  }
  
  var rotationGesture: some Gesture {
    RotationGesture()
      .onChanged { value in
        angle = finalAngle + value
      }
      .onEnded { value in
        finalAngle += value
      }
  }
  
  
  
  var dragGesture: some Gesture {
    DragGesture()
      .onChanged { value in
        offset = CGSize(width: finalOffset.width + value.translation.width, height: finalOffset.height + value.translation.height)
      }
      .onEnded { value in
        finalOffset = CGSize(width: finalOffset.width + value.translation.width, height: finalOffset.height + value.translation.height)
      }
  }
  
  
  var body: some View {
    VStack {
      // Back button
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
      Spacer()
      Text("Adjust Image").font(.title).padding()
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
      .simultaneousGesture(magnificationGesture
          .simultaneously(with: rotationGesture)
          .simultaneously(with: dragGesture)
      )
      
      
      Spacer()
      Button("Use Image") {
        saveTransformedImage()
        showTransformedImage = true
        if let transformedImage = opData.cameraModel.transformedImage {
          opData.lastView.append(opData.currView)
          opData.currView = .feedback
        }
      }.padding(.all)
        .background(Color(red: 0.83, green: 0.25, blue: 0.17))
        .foregroundColor(.white)
        .cornerRadius(15.0)
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
    //    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
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
    
    //      }
  }
  
  
}

