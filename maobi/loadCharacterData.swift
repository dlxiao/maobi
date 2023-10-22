import UIKit
import Foundation


// Data from graphics.txt, graphical coordinates for character
struct CharacterGraphics: Decodable {
  let character: String
  let strokes: [String]
  let medians: [[[Int]]]
  
  enum CodingKeys : String, CodingKey {
    case character = "character"
    case strokes = "strokes"
    case medians = "medians"
  }
}


// Data from dictionary.txt, background info about character
struct CharacterInfo: Decodable {
  let character: String
  let definition: String
  let pinyin: [String]
  
  enum CodingKeys : String, CodingKey {
    case character = "character"
    case definition = "definition"
    case pinyin = "pinyin"
  }
}


// Combined data for character graphics and info
struct CharacterData {
  var character : String
  var definition : String
  var pinyin : String
  var strokes : [String]
  var medians : [[[Int]]]
}


// Load graphics for characters from graphics.txt from https://github.com/skishore/makemeahanzi
// Currently using a subset, since there are 10k rows in the whole file
func loadGraphics() -> Dictionary<String, CharacterGraphics> {
  let fileurl = Bundle.main.url(forResource: "graphics_subset", withExtension: "txt")
  let contents = try! String(contentsOf: fileurl!, encoding: String.Encoding.utf8)
  var lines = contents.components(separatedBy: NSCharacterSet.newlines)
  lines.removeLast()

  var result : [String: CharacterGraphics] = [:]
  for line in lines {
    guard let lineEntry = try? JSONDecoder().decode(CharacterGraphics.self, from: Data(line.utf8)) else {
      print("Error decoding")
      return [:]
    }
    result[lineEntry.character] = lineEntry
  }
  return result
}


// Load character info for characters from dictionary.txt from https://github.com/skishore/makemeahanzi
// Currently using a subset, since there are 10k rows in the whole file
func loadInfo() -> Dictionary<String, CharacterInfo> {
  let fileurl = Bundle.main.url(forResource: "dictionary_subset", withExtension: "txt")
  let contents = try! String(contentsOf: fileurl!, encoding: String.Encoding.utf8)
  var lines = contents.components(separatedBy: NSCharacterSet.newlines)
  lines.removeLast()

  var result : [String: CharacterInfo] = [:]
  for line in lines {
    guard let lineEntry = try? JSONDecoder().decode(CharacterInfo.self, from: Data(line.utf8)) else {
      print("Error decoding")
      return [:]
    }
    result[lineEntry.character] = lineEntry
  }
  
  return result
}


// Combine all local data into one struct
func loadCharacterData() -> Dictionary<String, CharacterData> {
  let graphics = loadGraphics()
  let info = loadInfo()
  var result : Dictionary<String, CharacterData> = [:]
  for (character, graphicsData) in graphics {
    result[character] = CharacterData(character: character, definition: info[character]!.definition, pinyin: info[character]!.pinyin[0], strokes: graphicsData.strokes, medians: graphicsData.medians)
  }
  return result
}


// Works without internet by using local data
// Returns svg element of the character charName
func displayCharBySVG(_ charName : String, graphicsData : Dictionary<String, CharacterGraphics>) -> String {
    var result = """
      <svg viewBox='0 0 1024 1024'>
      <g transform="scale(1, -1) translate(0, -900)">
    """
  
  if let charData = graphicsData[charName] {
    for stroke in charData.strokes {
        result += "<path d='" + stroke + "'/>"
      }
  }
  return result + "</g></svg>"
}


// Uses api at https://hanziwriter.org/docs.html#api-link
// Returns page displaying character charName
func displayCharByAPI(_ charName : String, _ size : Int) -> String {
  return """
  <head>
    <script src="https://cdn.jsdelivr.net/npm/hanzi-writer@3.5/dist/hanzi-writer.min.js"></script>
  </head>
  <body>
    <div id="character-target-div"></div>
  </body>
  <script>
    var writer = HanziWriter.create('character-target-div', '\(charName)', {
      width: \(size),
      height: \(size),
      padding: 5,
      delayBetweenLoops: 1000
    });
  </script>
  """
}


func getLevelLabel(_ charName : String, _ allCharInfo : Dictionary<String, CharacterData>) -> String {
  
  if let charInfo = allCharInfo[charName] {
    return charName + " " + charInfo.pinyin
  } else {
    return charName + " Error:Data not found"
  }

}


func strokeOrderAnimation() -> String {
  var result = ""
  return result
}
