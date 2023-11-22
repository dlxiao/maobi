// This file loads user data from Firebase and provides methods to get / set user data

import Foundation
import Combine
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


struct User: Codable, Hashable {
  var userID : String
  var username: String
  var password: String
  var totalStars: Int
  var completedTutorial : Bool
  
  enum CodingKeys: CodingKey {
    case userID
    case username
    case password
    case totalStars
    case completedTutorial
  }
}

class UserRepository: ObservableObject {
  private let store = Firestore.firestore()
  @Published var userID = ""
  @Published var username = ""
  @Published var password = ""
  @Published var totalStars = 0
  @Published var completedTutorial = false
  @Published var success = false
  
  func getTotalStars() -> Int {
      return self.totalStars
  }
  
  func completeTutorial() {
    self.completedTutorial = true
    // Update in firebase
    let userRef = self.store.collection("user").document(self.userID)
    userRef.updateData([
      "completedTutorial": true
    ]) { err in
      if let err = err {
        print("Error completing tutorial: \(err).")
      } else {
        print("Tutorial completed.")
      }
    }
  }
  
  init(_ username : String, _ password : String) {
    self.username = username
    self.password = password
    
    // Initialize local data
    self.loadUser() { userResult in
      if let user = userResult {
        self.userID = user.userID
        self.totalStars = user.totalStars
        self.completedTutorial = user.completedTutorial
        self.success = true
        print("Initialized user: \(user)")
      } else {
        self.success = false
        print("Couldn't initialize user")
      }
    }
  }
  
  func loadUser(completion: @escaping (User?) -> Void) {
    store.collection("user")
      .whereField("username", isEqualTo: self.username)
      .whereField("password", isEqualTo: self.password)
      .limit(to: 1)
      .getDocuments() { (querySnapshot, err) in
        if let err = err {
          print("Error loading username=\(self.username), password=\(self.password) from Firebase: \(err).")
        } else {
          let data = querySnapshot?.documents.compactMap { document in
            try? document.data(as: User.self)
          } ?? []
          if(data.count != 1) {
            print("Error loading username=\(self.username), password=\(self.password) from Firebase: 0 or multiple users found.")
          } else {
            self.success = true
            completion(data[0])
          }
        }
      }
  }
  
  
  func loginUser(completion: @escaping ([User]?) -> Void) {
    store.collection("user")
      .whereField("username", isEqualTo: self.username)
      .whereField("password", isEqualTo: self.password)
      .limit(to: 1)
      .getDocuments() { (querySnapshot, err) in
        if let err = err {
          print("Error loading username=\(self.username), password=\(self.password) from Firebase: \(err).")
        } else {
          let data = querySnapshot?.documents.compactMap { document in
            try? document.data(as: User.self)
          } ?? []
          completion(data)
        }
      }
  }
  
  
}

//
//
//struct UserLevel: Codable, Hashable {
//  var userlevelID : String
//  var maxStars: Int
//  //TODO: change to character
//  var character: String
//  var unlockDate : Date
//
//  enum CodingKeys: CodingKey {
//    case userlevelID
//    case maxStars
//    case character
//    case unlockDate
//  }
//}
//
//struct Feedback: Codable, Hashable {
//  var userID : String
//  var feedbackID : String
//  var userlevelID : String
//  var stars: Int
//  var alignment: String
//  var strokeOrder : String
//  var thickness : String
//  var submissionDate : Date
//
//  enum CodingKeys: CodingKey {
//    case userID
//    case feedbackID
//    case userlevelID
//    case stars
//    case alignment
//    case strokeOrder
//    case thickness
//    case submissionDate
//  }
//}
//
//
//class UserRepository: ObservableObject {
//  private let store = Firestore.firestore()
//  @Published var user : User = User(userID: "", username: "", password: "", totalStars: 0, completedTutorial: false)
//
//  var userID = ""
//
//  private var userlevels : [UserLevel] = []
//  private var feedbacks : [Feedback] = []
//
//
//
//  // Interface methods
//
//  func completeTutorial() {
//    // Update in firebase
//    let userRef = self.store.collection("user").document(self.userID)
//    userRef.updateData([
//      "completedTutorial": true
//    ]) { err in
//      if let err = err {
//        print("Error completing tutorial: \(err).")
//      } else {
//        print("Tutorial completed.")
//      }
//    }
//    self.user.completedTutorial = true
//  }
//
//  func getUserID() -> String {
//    return self.userID
//  }
//
//  func getUsername() -> String {
//    return self.user.username
//  }
//
//  func setUsername(_ newUsername : String) -> Void {
//    self.user.username = newUsername
//  }
//
//  func getPassword() -> String {
//    return self.user.password
//  }
//
//  func setPassword(_ newPassword : String) -> Void {
//    self.user.password = newPassword
//  }
//
//  func getTotalStars() -> Int {
//    return self.user.totalStars
//  }
//
//  func setTotalStars(_ newTotal : Int) -> Void {
//    self.user.totalStars = newTotal
//  }
//
//  func getUserLevels(_ sort : String) -> [UserLevel] {
//    return self.userlevels
//  }
//
//  //TODO: get specific user level after database set up
//  func getUserLevel(_ level: Levels) -> UserLevel? {
//    return UserLevel(userlevelID: "", maxStars: 0, character: "", unlockDate : Date())
//  }
//
//  // TODO
//  func sortLevels(_ levels : [UserLevel], _ sortBy : String) -> [UserLevel] {
//    return []
//  }
//
//  // TODO
//  func filterLevels(_ levels : [UserLevel], _ stars : Int) -> [UserLevel] {
//    return []
//  }
//
//  func getAllFeedback() -> [Feedback] {
//    print(self.feedbacks)
//    return self.feedbacks
//  }
//
//  // TODO
//  func getFeedback(_ character : String) -> [Feedback] {
//    return []
//  }
//
//  // TODO
////  func attempt(_ character : String, _ image : Image) -> Feedback {
////    return
////  }
//
//  func addTotalStars(_ toAdd : Int) -> Int {
//    let newTotal = self.user.totalStars + toAdd
//    self.user.totalStars = newTotal
//    return newTotal
//  }
//
//  func updateMaxStars(userLevelId: String, newStars: Int) {
//      // Find the UserLevel object and update maxStars
//      if let index = self.userlevels.firstIndex(where: { $0.userlevelID == userLevelId }) {
//          let currentMaxStars = self.userlevels[index].maxStars
//          if newStars > currentMaxStars {
//              self.userlevels[index].maxStars = newStars
//              // Update Firebase (for both userlevel and user documents)
////              updateUserLevelInFirebase(userLevelId: userLevelId, newMaxStars: newStars)
////              updateUserInFirebase()
//          }
//      }
//  }
//
//  //TODO: When user login set up.
////  private func updateUserLevelInFirebase(userLevelId: String, newMaxStars: Int) {
////      let userLevelRef = store.collection("userlevel").document(userLevelId)
////      userLevelRef.updateData(["maxStars": newMaxStars]) { err in
////          if let err = err {
////              print("Error updating maxStars: \(err)")
////          } else {
////              print("maxStars successfully updated")
////          }
////      }
////  }
////
////  private func updateUserInFirebase() {
////      let userRef = store.collection("user").document(self.user.userID)
////      userRef.updateData(["totalStars": self.user.totalStars]) { err in
////          if let err = err {
////              print("Error updating totalStars: \(err)")
////          } else {
////              print("totalStars successfully updated")
////          }
////      }
////  }
//
//  // Loading data and private helpers
//  init(userID: String) {
//    self.userID = userID
//    loadUser(self.userID)
////    loadUserLevels(self.userID)
////    loadFeedbacks(self.userID)
//  }
//
//
//  // Loads all user data from Firebase and stores it in self.user
//  func loadUser(_ userID : String) {
//    self.store.collection("user").whereField("userID", isEqualTo: userID).limit(to: 1)
//      .getDocuments() { (querySnapshot, err) in
//        if let err = err {
//          print("Error loading current user (\(userID)) from Firebase: \(err).")
//        } else {
//          let data = querySnapshot?.documents.compactMap { document in
//            try? document.data(as: User.self)
//          } ?? []
//          if(data.count != 1) {
//            print("Error loading current user (\(userID)) from Firebase: 0 or multiple users found.")
//          } else {
//            self.user = data[0]
//          }
//        }
//      }
//  }
//
//  private func loadUserLevels(_ userID : String) {
//    self.store.collection("userlevel").whereField("userID", isEqualTo: userID)
//      .getDocuments() { (querySnapshot, err) in
//        if let err = err {
//          print("Error loading current user (\(userID)) from Firebase: \(err).")
//        } else {
//          self.userlevels = querySnapshot?.documents.compactMap { document in
//            try? document.data(as: UserLevel.self)
//          } ?? []
//        }
//      }
//  }
//
//  private func loadFeedbacks(_ userID : String) {
//    self.store.collection("feedback").whereField("userID", isEqualTo: userID)
//      .getDocuments() { (querySnapshot, err) in
//        if let err = err {
//          print("Error loading current user (\(userID)) from Firebase: \(err).")
//        } else {
//          self.feedbacks = querySnapshot?.documents.compactMap { document in
//            try? document.data(as: Feedback.self)
//          } ?? []
//        }
//      }
//  }
//
//}
//
//
//
//
//
