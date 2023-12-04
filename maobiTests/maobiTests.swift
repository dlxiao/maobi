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
import WebKit
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
  
  func testUser() {
    func onCreateAccount(_ formUsername : String, _ formPassword : String, _ formConfirmPassword : String, _ formEmail : String) -> Bool {
      var validAccount = true
      let emailValidation = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
      
      if(formPassword != formConfirmPassword) {
        validAccount = false
      } else if (!emailValidation.evaluate(with: formEmail)) {
        validAccount = false
      } else {
        validAccount = true
      }
      return validAccount
    }
    
    // Invalid account details to create - email malformed
    let formUsername2 = "UnitTestUsername"
    let formPassword2 = "UnitTestPassword"
    let formConfirmPassword2 = "UnitTestPassword"
    let formEmail2 = "UnitTestEmailInvalid"
    XCTAssertFalse(onCreateAccount(formUsername2, formPassword2, formConfirmPassword2, formEmail2))
    
    // Invalid account details to create - passwords don't match
    let formUsername3 = "UnitTestUsername"
    let formPassword3 = "UnitTestPassword"
    let formConfirmPassword3 = "UnitTestPasswordDifferent"
    let formEmail3 = "UnitTestEmail@domain.com"
    XCTAssertFalse(onCreateAccount(formUsername3, formPassword3, formConfirmPassword3, formEmail3))
    
    // Valid account details to create
    let exp = XCTestExpectation(description: "Create user")
    var validAccount = true
    let formUsername = "UnitTestUsername"
    let formPassword = "UnitTestPassword"
    let formConfirmPassword = "UnitTestPassword"
    let formEmail = "UnitTestEmail@domain.com"
    var userRepo = UserRepository(formUsername, formPassword, formEmail)
    // create account
    userRepo.createUser() { userResult in
      if let user = userResult {
        if(user.count != 1) {
          validAccount = false
        } else {
          var currUser = user[0]
          print(currUser)
          // Test initial new account details
          XCTAssertNotNil(currUser.userID)
          XCTAssertEqual(currUser.username,"UnitTestUsername")
          XCTAssertEqual(currUser.password,"UnitTestPassword")
          XCTAssertEqual(currUser.email,"UnitTestEmail@domain.com")
          XCTAssertEqual(currUser.totalStars,0)
          XCTAssertEqual(userRepo.getTotalStars(),0)
          XCTAssertFalse(currUser.completedTutorial)
          exp.fulfill()
          
          // Complete tutorial
          userRepo.completeTutorial()
          XCTAssertEqual(userRepo.getTotalStars(),10)
        }
      } 
    }
    XCTAssertTrue(onCreateAccount(formUsername, formPassword, formConfirmPassword, formEmail))
    self.wait(for: [exp], timeout: 20.0)
    
    let exp2 = XCTestExpectation(description: "Login and delete created user")
    // Log in again
    userRepo.loginUser() { userLoginResult in
      if let userLogin = userLoginResult {
        XCTAssertNotNil(userLogin[0].userID)
        XCTAssertEqual(userLogin[0].username,"UnitTestUsername")
        XCTAssertEqual(userLogin[0].password,"UnitTestPassword")
        XCTAssertEqual(userLogin[0].email,"UnitTestEmail@domain.com")
        XCTAssertEqual(userLogin[0].totalStars,10)
        
        // Delete document afterwards
        userRepo.store.collection("user").document(userRepo.userID).delete() { err in
          if let err = err {
            print("Error deleting user after testing: \(err)")
          } else {
            print("Deleted document \(userRepo.userID)")
            exp2.fulfill()
          }
        }
      }
    }
    self.wait(for: [exp2], timeout: 20.0)
    
  }
  
  
  
}
