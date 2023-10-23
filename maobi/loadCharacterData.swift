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


// Works without internet by using local data,
// and also handles edge case for "ti" and "na" that aren't in the dataset
// Returns svg element of the character charName
func displayCharBySVG(_ charName : String, _ allCharData : Dictionary<String, CharacterData>) -> String {
  var result = """
      <svg viewBox='0 0 1024 1024'>
      <g transform="scale(0.8, -0.8) translate(-200, -600)">
    """
  
  if let charData = allCharData[charName] {
    for stroke in charData.strokes {
      result += "<path fill='#555555' d='" + stroke + "'/>"
    }
  }
  return result + "</g></svg>"
}


// Displays animation of two strokes that are missing from data: "ti" and "na"
func displayAnimatedMissing(_ charName : String, _ allCharData : Dictionary<String, CharacterData>) -> String {
  
  var result = """
      <svg viewBox='0 0 1024 1024'>
            <defs>
                <linearGradient id="left-to-right">
                  <stop offset="0" stop-color="#555555">
                    <animate dur="1s" attributeName="offset" fill="freeze" from="0" to="1" repeatCount="indefinite" />
                  </stop>
                  <stop offset="0" stop-color="#DDDDDD">
                    <animate dur="1s" attributeName="offset" fill="freeze" from="0" to="1" repeatCount="indefinite" />
                  </stop>
                  
                </linearGradient>
              </defs>
      <g transform="scale(0.8, -0.8) translate(-200, -600)">
        
    """
  
  if let charData = allCharData[charName] {
    for stroke in charData.strokes {
      result += "<path fill='url(#left-to-right)'; d='" + stroke + "'/>"
    }
  }
  return result + "</g></svg>"
}


// Returns text label of navigation row for the given character
func getLevelLabel(_ charName : String, _ allCharData : Dictionary<String, CharacterData>) -> String {
  
  if let charInfo = allCharData[charName] {
    return charName + " " + charInfo.pinyin
  } else {
    return charName + " Error:Data not found"
  }
  
}


// Demo to display char info, image, and animation
func displayLevel(_ charName : String, _ allCharData : Dictionary<String, CharacterData>) -> String {
  let currChar = allCharData[charName]!
  let currPinyin = "Pinyin: " + currChar.pinyin
  let currDefinition = "Definition: " + currChar.definition
  var staticChar : String
  var animatedChar : String
  var charLookup = (charName == " ` ") ? "丶" : charName
  
  if(charName == "丶" || charName == "ノ") {
    staticChar = displayCharBySVG(charName, allCharData)
    animatedChar = displayAnimatedMissing(charName, allCharData)
    return """
      <body style="padding:10%;">
        <h1>\(currPinyin)</h1>
        <h1>\(currDefinition)</h1>
        <br><br>
        <h1>Picture</h1>
        <div id="static-target">\(staticChar)</div>
        <h1>Animation</h1>
        <div id="animated-target">\(animatedChar)</div>
      </body>
    """
  }
  return """
      <head>
        <script src="https://cdn.jsdelivr.net/npm/hanzi-writer@3.5/dist/hanzi-writer.min.js"></script>
      </head>
      <body style="padding:10%;">
        <h1>\(currPinyin)</h1>
        <h1>\(currDefinition)</h1>
        <br><br>
        <h1>Picture</h1>
        <div id="static-target"></div>
        <h1>Animation</h1>
        <div id="animated-target"></div>
      </body>
      <script>
        HanziWriter.create('static-target', '\(charLookup)', {
          width: 500,
          height: 500,
          padding: 5
        });
        var writer = HanziWriter.create('animated-target', '\(charLookup)', {
          width: 500,
          height: 500,
          padding: 5,
          delayBetweenLoops: 1000
        });
        writer.loopCharacterAnimation();
      </script>
  """
}
