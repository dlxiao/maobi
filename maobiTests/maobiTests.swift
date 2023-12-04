//
//  maobiTests.swift
//  maobiTests
//
//  Created by Dora Xiao on 11/29/23.
//

import XCTest
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
@testable import maobi


final class maobiTests: XCTestCase {
  let levels = Levels()
  let characterStrings = ["二", "小", "心", "川", "十", "门", "八", "六"]
  let basicStrokeStrings = ["一", "丨", " ` ", "亅", "丶", "丿", "ノ"]
  
  override func setUpWithError() throws {
    print("setup with error")
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    print("teardown with error")
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  override func setUp() {
    super.setUp()
    
    print("finished setup")
  }
  
  override func tearDown() {
    super.tearDown()
    print("finished teardown")
  }
  
//  func testCreateUser() {
//    //    let testuser = UserRepository("sampleusername_1", "password_1")
//    print("Testing")
//    //    XCTAssertEqual(0, 0, "testing")
//    print("Done testing")
//  }
  
  
  func testCharactersAndFingerDraw() {
    // Check we get correct basic strokes and character levels
    let basicStrokes = self.levels.getBasicStrokes()
    let characterLevels = self.levels.getCharacterLevels()
    for c in basicStrokes {
      let cString = c.toString()
      XCTAssertTrue(self.basicStrokeStrings.contains(cString))
      
      // Check details of character data
      let cData = levels.getCharacter(cString)
      let definition = cData.getDefinition()
      let pinyin = cData.getPinyin()
      let levelHTML = cData.getLevelHTML()
      
      XCTAssertNotNil(definition)
      XCTAssertNotNil(pinyin)
      XCTAssertTrue(levelHTML.contains(cString) || levelHTML.contains("svg"))
      if(cString == "心") {
        XCTAssertEqual(definition, "heart; mind; soul")
        XCTAssertEqual(pinyin, "xīn")
      }
    }
    for c in characterLevels {
      let cString = c.toString()
      XCTAssertTrue(self.characterStrings.contains(cString))
      
      // Check details of character data
      let cData = levels.getCharacter(cString)
      let definition = cData.getDefinition()
      let pinyin = cData.getPinyin()
      let levelHTML = cData.getLevelHTML()
      
      XCTAssertNotNil(definition)
      XCTAssertNotNil(pinyin)
      XCTAssertTrue(levelHTML.contains(cString))
      if(cString == "心") {
        XCTAssertEqual(definition, "heart; mind; soul")
        XCTAssertEqual(pinyin, "xīn")
      }
    }
  }
  
  // Instantiate a fingerDraw and check that its properties are stored correctly
  // and check the HTML generated for the quiz contains the correct character.
  func testFingerDraw() {
    // test for every character in the app
    for c in self.characterStrings {
      var fingerDraw = FingerDraw(character: c, size: 500)
      XCTAssertEqual(fingerDraw.character, c)
      XCTAssertEqual(fingerDraw.size, 500)
      let quiz = fingerDraw.getIndividualQuizHTML()
      XCTAssertTrue(quiz.contains(c))
    }
  }
  
  
  
  
}
