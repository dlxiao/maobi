// This file loads character data and provides methods to use it

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


// Combined all character data here
class CharacterData : Identifiable {
  private var character : String
  private var definition : String
  private var pinyin : String
  private var strokes : [String]
  private var medians : [[[Int]]]
  
  init(character: String, definition: String, pinyin: String, strokes: [String], medians: [[[Int]]]) {
    self.character = character
    self.definition = definition
    self.pinyin = pinyin
    self.strokes = strokes
    self.medians = medians
  }
  
  func getImage(_ size : Int = 500) -> (String, String) {
    var charLookup = (self.character == " ` ") ? "丶" : self.character
    if(charLookup == "丶" || charLookup == "ノ") {
      var paths = (self.strokes.map() { "<path fill='#555555' d='" + $0 + "'/>" }).joined()
      var svg = """
        <svg viewBox='0 0 1024 1024'>
          <g transform="scale(1.0, -1.0) translate(0, -900)">
            \(paths)
          </g>
        </svg>
      """
      return (svg, "")
    } else {
      let div = "<div id='image-\(charLookup)'></div>"
      let script = """
        var image\(charLookup) = HanziWriter.create('image-\(charLookup)', '\(charLookup)', {
          width: \(size),
          height: \(size),
          padding: 5
        });
      """
      return (div, script)
    }
  }
  
  func getAnimation(_ size : Int = 500) -> (String, String) {
    var charLookup = (self.character == " ` ") ? "丶" : self.character
    if(charLookup == "丶" || charLookup == "ノ") {
      let paths = (self.strokes.map() { "<path fill='url(#left-to-right)'; d='" + $0 + "'/>" }).joined()
      var svg = """
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
          <g transform="scale(1.0, -1.0) translate(0, -900)">\(paths)</g></svg>
        """
      return (svg, "")
    } else {
      var div = "<div id='animation-\(charLookup)'></div>"
      var script = """
        var animation\(charLookup) = HanziWriter.create('animation-\(charLookup)', '\(charLookup)', {
          width: \(size),
          height: \(size),
          padding: 5,
          delayBetweenLoops: 1000
        });
        animation\(charLookup).loopCharacterAnimation();
      """
      return (div, script)
    }
  }
  
  // Only run this on what's in the tutorial wireframes bc doesn't catch edge cases
  func getQuiz(_ size : Int = 500) -> (String, String) {
    var div = "<div id='quiz-\(self.character)'></div>"
    var script = """
      var writer2 = HanziWriter.create('quiz-\(self.character)', '\(self.character)', {
        width: \(size),
        height: \(size),
        showCharacter: false,
        padding: 5
      });
      writer2.quiz();
    """
    return (div, script)
  }
  
  func getPinyin() -> String {
    return self.pinyin
  }
  
  func getDefinition() -> String {
    return self.definition
  }
  
  func toString() -> String {
    return self.character
  }

}


class Levels {
  // Hardcoded characters available, for now
  private var basicStrokes = ["一", "丨", " ` ", "亅", "丶", "丿", "ノ"]
  private var sampleCharacters = ["大", "小", "水", "天", "王", "十", "九", "八", "七", "六"]
  private var allCharacters : Dictionary<String, CharacterData> = [:]
  
  init() {
    self.allCharacters = loadCharacterData()
  }
  
  // DELETE LATER - example of how to compose pages and get character image / animation
  func example() -> String {
    let chars = ["一", "丨", " ` ", "亅", "丶", "丿", "ノ", "大", "小", "水", "天", "王", "十", "九", "八", "七", "六"]
    var divs = ""
    var scripts = ""
    for char in chars {
      let (d1, s1) = self.getCharacter(char).getImage()
      let (d2, s2) = self.getCharacter(char).getAnimation()
      divs += (d1 + d2)
      scripts += (s1+s2)
    }
    
    return """
    <head><script src="https://cdn.jsdelivr.net/npm/hanzi-writer@3.5/dist/hanzi-writer.min.js"></script></head>
    <body style="padding:10%;">\(divs)</body>
    <script>\(scripts)</script>
    """
  }
  
  func getCharacter(_ character : String) -> CharacterData {
    return self.allCharacters[character]!
  }
  
  func getBasicStrokes() -> [CharacterData] {
      let basicStrokes = self.allCharacters.filter { self.basicStrokes.contains($0.0) }.map { $0.1 }
      return basicStrokes.sorted(by: { $0.getPinyin() < $1.getPinyin() })
    }
    
    func getCharacterLevels() -> [CharacterData] {
      let basicStrokes = self.allCharacters.filter { self.sampleCharacters.contains($0.0) }.map { $0.1 }
      return basicStrokes.sorted(by: { $0.getPinyin() < $1.getPinyin() })
    }
  
  // Load graphics for characters from graphics.txt from https://github.com/skishore/makemeahanzi
  // Currently using a subset, since there are 10k rows in the whole file
  private func loadGraphics() -> Dictionary<String, CharacterGraphics> {
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
  private func loadInfo() -> Dictionary<String, CharacterInfo> {
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

  // Combine all local data into one
  private func loadCharacterData() -> Dictionary<String, CharacterData> {
    let graphics = loadGraphics()
    let info = loadInfo()
    var result : Dictionary<String, CharacterData> = [:]
    for (character, graphicsData) in graphics {
      result[character] = CharacterData(character: character, definition: info[character]!.definition, pinyin: info[character]!.pinyin[0], strokes: graphicsData.strokes, medians: graphicsData.medians)
    }
    return result
  }

}
