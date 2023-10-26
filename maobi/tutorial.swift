import Foundation
import UIKit



func getTutorial() -> String {
  return """
  <script src="https://cdn.jsdelivr.net/npm/hanzi-writer@3.5/dist/hanzi-writer.min.js"></script>
  <body style="padding:10%;">
    <h1 style="font-size:80px;">Demo of Finger-Writing for Tutorial</h1><br>
    <h1 style="font-size:50px;">Try copying this animation. Click and drag with your mouse:</h1>
    <div id='stroke-order-div'></div><br>
    <div id='character-target-div'></div>
  </body>
  <script>
    var writer = HanziWriter.create('character-target-div', '水', {
        width: 300,
        height: 300,
        showCharacter: false,
        padding: 10,
        delayBetweenLoops: 1000
    });
    writer.loopCharacterAnimation();
    var writer2 = HanziWriter.create('character-target-div', '水', {
      width: 700,
      height: 700,
      showCharacter: false,
      padding: 10
    });
    writer2.quiz();
  </script>
  """
}
