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
  
  func testCreateUser() {
    //    let testuser = UserRepository("sampleusername_1", "password_1")
    print("Testing")
    //    XCTAssertEqual(0, 0, "testing")
    print("Done testing")
  }
  
}
