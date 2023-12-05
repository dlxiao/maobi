//
//  FingerDraw.swift
//  maobi
//
//  Created by Lucy on 11/6/23.
//

import Foundation

class FingerDraw : Identifiable {
  var character : String
  var size : Int
  init(character: String, size: Int) {
    self.character = character
    self.size = size
  }
  
  func getIndividualQuizHTML() -> String {
    """
    <head><script src="https://cdn.jsdelivr.net/npm/hanzi-writer@3.5/dist/hanzi-writer.min.js"></script></head>
    <body style="padding:10%;">
      <div style='text-align: center; margin: 0;position: absolute;top: 50%;left: 50%;-ms-transform: translate(-50%, -50%);transform: translate(-50%, -50%);'>
      <h1 id='msg' style='color: black; font-family: -apple-system, BlinkMacSystemFont, sans-serif; font-size: 64px'>Try this stroke:</h1>
      <div id="character-target-div1"></div>
    </body>
    <script>
    var writer1 = HanziWriter.create('character-target-div1', '\(self.character)', {
      width: \(self.size),
      height: \(self.size),
      padding: 5,
      delayBetweenLoops: 3000
    });
    writer1.quiz({
    onComplete: function(summaryData) {
        document.getElementById("msg").innerHTML = "Nice work!";
        }
     });
    </script>
    """
  }
}


