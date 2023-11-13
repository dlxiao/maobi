//
//  FingerDraw.swift
//  maobi
//
//  Created by Lucy on 11/6/23.
//

import Foundation

class FingerDraw : Identifiable {
  private var character : String
  private var size : Int
  init(character: String, size: Int) {
    self.character = character
    self.size = size
  }
  func getQuiz() -> (String, String) {
    var div = "<div id='quiz-\(self.character)'></div>"
    var script = """
      var writer2 = HanziWriter.create('quiz-\(self.character)', '\(self.character)', {
        width: \(self.size),
        height: \(self.size),
        showCharacter: false,
        padding: 5
      });
      writer2.quiz();
    """
    return (div, script)
  }
  func getQuizHTML() -> String {
    let (d1, s1) = self.getQuiz()
    return """
    <head><script src="https://cdn.jsdelivr.net/npm/hanzi-writer@3.5/dist/hanzi-writer.min.js"></script></head>
    <body style="padding:5%;">\(d1)</body>
    <script>\(s1)</script>
    """
  }
}
