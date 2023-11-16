//import SwiftUI
//
//struct LevelView: View {
//  var character : CharacterData
//  var levels : Levels
//  @StateObject var cameraModel = CameraModel()
//  var user : UserRepository
//
//  var body: some View {
//    VStack {
//      Text(character.toString() + "  |  " + character.getPinyin()).font(.largeTitle).padding(20)
//      Text("This character means \"" + character.getDefinition() + "\". To write it, follow the stroke order animation below:").padding(20)
//
//      LevelGraphicsView(html: character.getLevelHTML()) // pass in image and animation
//      Button(action: {}) {
//        if(["一", "丨", " ` ", "亅", "丶", "丿", "ノ", "小", "十","八", "二"].contains(character.toString())) {
//          NavigationLink(
//            destination: CameraView(levels: levels, cameraModel: cameraModel, character: character, user:user)
//              .navigationBarTitle(""),
//            label: { Text("Check your Work!").fontWeight(.bold)
//            })
//        } else {
//          Text("Check your Work!").fontWeight(.bold)
//        }
//      }.padding(.all)
//        .background(Color(red: 0.83, green: 0.25, blue: 0.17))
//        .foregroundColor(.white)
//        .cornerRadius(15.0)
//    }.padding([.bottom], 50)
//
//
//  }
//
//}
//
//
