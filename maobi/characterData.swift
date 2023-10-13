import UIKit
import Foundation

struct graphicsLine: Decodable {
  let character: String
  let strokes: [String]
  
  enum CodingKeys : String, CodingKey {
    case character = "character"
    case strokes = "strokes"
  }
}

// Load graphics for all characters from txt
func getGraphics() -> Dictionary<String,[String]> {
  let fileurl = Bundle.main.url(forResource: "graphics_short", withExtension: "txt")
  let contents = try! String(contentsOf: fileurl!, encoding: String.Encoding.utf8)
  var lines = contents.components(separatedBy: NSCharacterSet.newlines)
  lines.removeLast()
  let linesCt = lines.count

  var result : [String: [String]] = [:]
  for line in lines {
    guard let lineEntry = try? JSONDecoder().decode(graphicsLine.self, from: Data(line.utf8)) else {
      print("Error decoding")
      return ["":[""]]
    }
    result[lineEntry.character] = lineEntry.strokes
  }
  return result
}

  
// Convert SVGPath of one stroke to UIBezierPath element
func getStrokeBezierPath(_ strokeStr: String) -> UIBezierPath {
  
  let stroke = strokeStr.components(separatedBy: " ")
    
  let path = UIBezierPath()
  let strokeComp = stroke.dropFirst(3).dropLast(1)

  if(stroke.first == "M" && stroke.last == "Z") {
    let xVal = Int(stroke[1]) ?? 0
    let yVal = Int(stroke[2]) ?? 0
    path.move(to: CGPoint(x: xVal, y: yVal))
  } else {
    print("Error in stroke formatting")
  }

  var i = 3
  print(strokeComp)
  while (i < strokeComp.count) {
    let elemType = strokeComp[i]
    if(elemType == "Q") { // Curve
      let xVal1 = Int(strokeComp[i+1]) ?? 0
      let yVal1 = Int(strokeComp[i+2]) ?? 0
      let xVal2 = Int(strokeComp[i+3]) ?? 0
      let yVal2 = Int(strokeComp[i+4]) ?? 0
      path.addCurve(to: CGPoint(x: xVal2, y: yVal2), controlPoint1: CGPoint(x: xVal1, y: yVal1), controlPoint2: CGPoint(x: xVal1, y: yVal1))
      i += 5
    } else if(elemType == "L") { // Line
      let xVal = Int(strokeComp[i+1]) ?? 0
      let yVal = Int(strokeComp[i+2]) ?? 0
      path.addLine(to: CGPoint(x: xVal, y: yVal))
      i += 3
    } else if(elemType == "C") {
      let xVal1 = Int(strokeComp[i+1]) ?? 0
      let yVal1 = Int(strokeComp[i+2]) ?? 0
      let xVal2 = Int(strokeComp[i+3]) ?? 0
      let yVal2 = Int(strokeComp[i+4]) ?? 0
      let xVal3 = Int(strokeComp[i+5]) ?? 0
      let yVal3 = Int(strokeComp[i+6]) ?? 0
      path.addCurve(to: CGPoint(x: xVal3, y: yVal3), controlPoint1: CGPoint(x: xVal1, y: yVal1), controlPoint2: CGPoint(x: xVal2, y: yVal2))
      i += 7
    } else {
      print("Error: unrecognized SVG element")
      i += strokeComp.count
    }
  }

  path.close()

  return path
}


// Get all UIBezierPath elements for all strokes in the character
func getCharacterBezierPaths(_ charName: String) -> [UIBezierPath] {
  if let strokes = getGraphics()[charName] {
    
    var paths : [UIBezierPath] = []
      for stroke in strokes {
        paths.append(getStrokeBezierPath(stroke))
      }
      return paths
  }
  print("Character doesn't exist")
  return []
}


func displayChar(_ charName : String) -> String {
    var result = """
    <html>
    <body>
      <svg viewBox='0 0 1024 1024'>
      <g transform="scale(1, -1) translate(0, -900)">
    """
  
  if let strokes = getGraphics()[charName] {
      for stroke in strokes {
        result += "<path d='" + stroke + "'/>"
      }
  }
  return result + "</g></svg></body></html>"
}
