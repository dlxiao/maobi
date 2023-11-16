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
    var div = "<h1 id='msg' style='display: none'>Nice work!</h1><div id='quiz-\(self.character)'></div>"
    var script = """
      var writer2 = HanziWriter.create('quiz-\(self.character)', '\(self.character)', {
        width: \(self.size),
        height: \(self.size),
        showCharacter: false,
        padding: 5
      });
      writer2.quiz({
        onComplete: function(summaryData) {
          document.getElementById('#msg').style.display = 'block'
        }
      });
    });
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
  
  func getQuizDynamicHTML() -> String {
    """
    <head><script src="https://cdn.jsdelivr.net/npm/hanzi-writer@3.5/dist/hanzi-writer.min.js"></script></head>
    <body style="padding:10%;">
    <div style='text-align: center; margin: 0;position: absolute;top: 50%;left: 50%;-ms-transform: translate(-50%, -50%);transform: translate(-50%, -50%);'>
    <h1 id='msg' style='color: white; font-family: -apple-system, BlinkMacSystemFont, sans-serif; font-size: 64px'>Nice work!</h1>
    <div id="character-target-div1"></div>
    <div id="character-target-div2" style='display: none;'></div>
    <div id="character-target-div3" style='display: none;'></div>
    <p id='ct'>1</p>
    </div>

    </body>

    <script>
    var writer1 = HanziWriter.create('character-target-div1', '一', {
      width: \(self.size),
      height: \(self.size),
      padding: 5,
      delayBetweenLoops: 3000
    });
    writer1.quiz({
    onComplete: function(summaryData) {
        document.getElementById("msg").style.color = "black";
        setTimeout(function() {
            document.getElementById("msg").style.color = "white";
            document.getElementById("character-target-div1").style.display = "none";
            document.getElementById("character-target-div2").style.display = "block";
          }, 1500);
        }
     });
  
      
          var writer2 = HanziWriter.create('character-target-div2', '丨', {
            width: \(self.size),
            height: \(self.size),
            padding: 5,
            delayBetweenLoops: 3000
          });
          writer2.quiz({
          onComplete: function(summaryData) {
              document.getElementById("msg").style.color = "black";
              setTimeout(function() {
                  document.getElementById("msg").style.color = "white";
                  document.getElementById("character-target-div2").style.display = "none";
                  document.getElementById("character-target-div3").style.display = "block";
                }, 1500);
              }
           });
  
            var writer3 = HanziWriter.create('character-target-div3', '十', {
              width: \(self.size),
              height: \(self.size),
              padding: 5,
              delayBetweenLoops: 3000
            });
            writer3.quiz({
            onComplete: function(summaryData) {
                document.getElementById("msg").style.color = "black";
                setTimeout(function() {
                    document.getElementById("msg").style.color = "white";
                    document.getElementById("character-target-div3").style.display = "none";
                  }, 1500);
                }
             });
      
    </script>
  """
  }
}


