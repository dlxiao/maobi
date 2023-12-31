import SwiftUI

#if !TESTING
struct LevelView: View {
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
      Text("This character means \"" + character.getDefinition() + "\". To write it, follow the stroke order animation below:").padding(20)
      
      LevelGraphicsView(html: character.getLevelHTML()) // pass in image and animation
      
      if((opData.levels.getBasicStrokesStrings()).contains(opData.character!.toString())) {
        Button(action: {
          opData.lastView.append(.level) // Store the current view
          opData.currView = .camera
        }) {
          Text("Check Your Work!").fontWeight(.bold)
        }.padding(.all)
          .background(Color(red: 0.83, green: 0.25, blue: 0.17))
          .foregroundColor(.white)
          .cornerRadius(15.0)
      } else {
        Button(action: {
          opData.lastView.append(.level) // Store the current view
          opData.currView = .levelquiz
        }) {
          Text("Check Your Stroke Order").fontWeight(.bold)
        }.padding(.all)
          .background(Color(red: 0.83, green: 0.25, blue: 0.17))
          .foregroundColor(.white)
          .cornerRadius(15.0)
      }
      
      
      
    }.padding([.bottom], 50)
  }
}
#endif

