import Foundation
import UIKit



func getTutorial() -> String {
  return """
  <script src="https://cdn.jsdelivr.net/npm/hanzi-writer@3.5/dist/hanzi-writer.min.js"></script>
  <body style="padding:10%;">
    <h1 style="font-size:80px;">Demo of Finger-Writing for Tutorial</h1><br>
    <h1 style="font-size:50px;">You can draw with your mouse</h1><br>
    <div id='character-target-div'></div>
  </body>
  <script>
    var writer = HanziWriter.create('character-target-div', '水', {
      width: 700,
      height: 700,
      showCharacter: false,
      padding: 10
    });
    writer.quiz();
  </script>
  """
}
