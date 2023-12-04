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
    
    // TODO: how to test cases where Firebase errs (actual error, not returning 0 results)?
    
  }
  
  func testContoursAndFeedback() {
    // Generate a perfect submission
    let template = UIImage.init(named: "小_template")!
    let submission = UIImage.init(named: "小_allperfect")!
    let feedback = ProcessImage(submission: submission, template: template, character: "小")
    XCTAssertEqual(feedback.stars, 3)
    XCTAssertEqual(feedback.overallMsg, "Awesome Work!")
    XCTAssertEqual(feedback.alignmentMsg, "Perfect alignment!")
    XCTAssertEqual(feedback.thicknessMsg, "Perfect thickness!")
    
    // Shape clicked - returns which stroke was clicked
    XCTAssertEqual(feedback.shapeClicked(feedback.strokes[0].contourpts[3]), 0)
    XCTAssertEqual(feedback.shapeClicked(feedback.strokes[0].contourpts[14]), 0)
    XCTAssertEqual(feedback.shapeClicked(feedback.strokes[1].contourpts[5]), 1)
    XCTAssertEqual(feedback.shapeClicked(feedback.strokes[1].contourpts[23]), 1)
    XCTAssertEqual(feedback.shapeClicked(feedback.strokes[2].contourpts[8]), 2)
    XCTAssertEqual(feedback.shapeClicked(feedback.strokes[2].contourpts[17]), 2)
    // random point that's not in a stroke, should return -1
    XCTAssertEqual(feedback.shapeClicked(CGPoint(x:0, y: 530)), -1)
    XCTAssertEqual(feedback.shapeClicked(CGPoint(x:-30, y: 20)), -1)
    
    // Generate submission with invalid input image provided
    let invalidInputFilter = CustomFilter()
    invalidInputFilter.inputImage = nil
    XCTAssertNil(invalidInputFilter.outputImage)
    
    // Invalid contours detected
    let submission2 = UIImage.init(named: "blank")!
    let feedback2 = ProcessImage(submission: submission2, template: template, character: "小")
    XCTAssertEqual(feedback2.stars, 0)
    XCTAssertEqual(feedback2.overallMsg, "Invalid or misaligned photo. Please retry.")
    
    // Test submission contour path is correct according to template contour path
    let submission3 = UIImage.init(named: "小_template")!
    let feedback3 = ProcessImage(submission: submission3, template: template, character: "小")
    let temp_cntr = CharacterContour(feedback3.templatePts)
    XCTAssertNotNil(temp_cntr.path(in: CGRect()))
    let sub_cntr = feedback3.strokes[2]
    XCTAssertNotNil(sub_cntr.path(in: CGRect()))
    XCTAssertNotNil(sub_cntr.makeOutline())
    temp_cntr.makeOutline()
    
    for (index, item) in sub_cntr.contourpts.enumerated() {
      if index.isMultiple(of: 20) {
        XCTAssertTrue(temp_cntr.outline.contains(item))
      }
    }
    
    // Different feedback messages
    // This one is too thin and crooked - 1 star
    let submission4 = UIImage.init(named: "小_thin")!
    let feedback4 = ProcessImage(submission: submission4, template: template, character: "小")
    XCTAssertEqual(feedback4.stars, 1)
    XCTAssertEqual(feedback4.overallMsg, "Try again.")
    XCTAssertEqual(feedback4.alignmentMsg, "Good start.")
    XCTAssertEqual(feedback4.thicknessMsg, "Good start.")
    
    // This one is too thick but has good alignment - 2 stars
    let submission5 = UIImage.init(named: "小_thick")!
    let feedback5 = ProcessImage(submission: submission5, template: template, character: "小")
    XCTAssertEqual(feedback5.stars, 2)
    XCTAssertEqual(feedback5.overallMsg, "Good progress.")
    XCTAssertEqual(feedback5.alignmentMsg, "Perfect alignment!")
    XCTAssertEqual(feedback5.thicknessMsg, "Good start.")
    
    // TODO: This one is misaligned
    
    
    
    
    
    // Characters with anchor points - example: ten
    let template2 = UIImage.init(named: "十_good")!
    let submission6 = UIImage.init(named: "十_template")!
    let feedback6 = ProcessImage(submission: submission5, template: template, character: "十")
    XCTAssertEqual(feedback5.stars, 2)
    XCTAssertEqual(feedback5.overallMsg, "Good progress.")
    XCTAssertEqual(feedback5.alignmentMsg, "Perfect alignment!")
    XCTAssertEqual(feedback5.thicknessMsg, "Good start.")
    
  }
  
  
  func testCameraModel() {
    var cm = CameraModel()
    let testImg = UIImage(named: "小_template")!
    cm.storeImage(testImg)
    XCTAssertNotNil(cm.image)
    cm.overlayImage(character: levels.getCharacter("小"))
    XCTAssertNotNil(cm.composedImage)
    
    
    // Try to overlay onto nil image
    var cm2 = CameraModel()
    cm2.image = nil
    XCTAssertNil(cm2.image)
    cm2.overlayImage(character: levels.getCharacter("二"))
    XCTAssertNil(cm2.composedImage)
    
    // Try to overlay template not found
    var cm3 = CameraModel()
    cm3.image = testImg
    XCTAssertNotNil(cm.image)
    cm.overlayImage(character: levels.getCharacter("m"))
    XCTAssertNil(cm3.composedImage)

  }
  
  func testPadding() {
    let testImg = UIImage(named: "小_template")!
    XCTAssertNotNil(testImg)
    let oldSize = testImg.size
    var paddedImg = testImg.addImagePadding(x: 100.0, y: 100.0)
    XCTAssertNotNil(paddedImg)
    let newSize = paddedImg!.size
    XCTAssertEqual(newSize.width, 100.0+oldSize.width)
    XCTAssertEqual(newSize.height, 100.0+oldSize.height)
  }
  
  func testResize() {
    let testImg = UIImage(named: "小_template")!
    let resizedImg = resizeImage(image: testImg, newWidth: 100.0)!
    let newSize = resizedImg.size
    XCTAssertEqual(newSize.width, 100.0)
    XCTAssertEqual(newSize.height, 100.0)
  }
  
  func testBinarize() {
    let testImg = UIImage(named: "小_template")!
    let oldSize = testImg.size
    let resultImg = binarize(testImg)
    let newSize = resultImg.size
    XCTAssertEqual(newSize.width, oldSize.width)
    XCTAssertEqual(newSize.height, oldSize.height)
    
    // guard against nil filter
    let tf = ThresholdFilter()
    XCTAssertNil(tf.inputImage)
    XCTAssertNil(tf.outputImage)
  }
  
  func testZoom() {
    let testImg = UIImage(named: "小_template")!
    let resultImg = transformSubmission(submissionZoom: 120.0, templateZoom: 120.0, translation: (10, 20), submission: testImg, template: testImg)
    // Make sure properly cropped to original size
    let newSize = resultImg.size
    XCTAssertEqual(newSize.width, 400.0)
    XCTAssertEqual(newSize.height, 400.0)
  }
  
}
