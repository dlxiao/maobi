import SwiftUI

struct LevelView: View {
  @StateObject var cameraModel = CameraModel()
  var character : CharacterData

  var body: some View {
    VStack {
      Text(character.toString() + "  |  " + character.getPinyin()).font(.largeTitle).padding(20)
      Text("This character means \"" + character.getDefinition() + "\". To write it, follow the stroke order animation below:").padding(20)
      
      LevelGraphicsView(html: character.getLevelHTML()) // pass in image and animation
      Button(action: {}) {
        NavigationLink(
          destination: CameraView(cameraModel: cameraModel, character: character),
          label: { Text("Check your Work!").fontWeight(.bold)
          })
      }.padding(.all)
        .background(Color(red: 0.83, green: 0.25, blue: 0.17))
        .foregroundColor(.white)
        .cornerRadius(15.0)
    }.padding([.bottom], 50)
    
    
  }

}


