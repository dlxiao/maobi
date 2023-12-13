import SwiftUI

#if !TESTING
struct LevelQuizView: View {
  @EnvironmentObject var opData : OpData
//  @StateObject var cameraModel = CameraModel()
  
  var body: some View {
    let character = opData.character!
    VStack {
      // Back button
      HStack {
        Button(action: {
          opData.currView = opData.lastView.removeLast()
        }) {
          HStack {
            Image(systemName: "chevron.left")
            Text("Back")
          }.foregroundColor(.black).font(.title3).fontWeight(.bold)
        }.frame(maxWidth: .infinity, alignment: .leading)
      }.padding()
      
      // Content
      Text(character.toString() + "  |  " + character.getPinyin()).font(.largeTitle).padding(20)
      Text("Check your understanding of this character's stroke order. Use your finger to trace the strokes below: ").padding(20)
      
      LevelGraphicsView(html: FingerDraw(character: character.toString(), size: 800).getLevelQuizHTML()) // pass in image and animation
      Button(action: {
        opData.lastView.append(.levelquiz) // Store the current view
        opData.currView = .camera
      }) {
        Text("Check Your Work!").fontWeight(.bold)
      }.padding(.all)
        .background(Color(red: 0.83, green: 0.25, blue: 0.17))
        .foregroundColor(.white)
        .cornerRadius(15.0)
    }.padding([.bottom], 50)
  }
}
#endif

