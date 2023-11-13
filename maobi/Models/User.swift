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
  
  enum CodingKeys: CodingKey {
    case userID
    case username
    case password
    case totalStars
  }
}

struct UserLevel: Codable, Hashable {
  var userlevelID : String
  var maxStars: Int
  var character: String
  var unlockDate : Date
  
  enum CodingKeys: CodingKey {
    case userlevelID
    case maxStars
    case character
    case unlockDate
  }
}

struct Feedback: Codable, Hashable {
  var userID : String
  var feedbackID : String
  var userlevelID : String
  var stars: Int
  var alignment: String
  var strokeOrder : String
  var thickness : String
  var submissionDate : Date
  
  enum CodingKeys: CodingKey {
    case userID
    case feedbackID
    case userlevelID
    case stars
    case alignment
    case strokeOrder
    case thickness
    case submissionDate
  }
}


class UserRepository: ObservableObject {
  private let store = Firestore.firestore()
  @Published var user : User = User(userID: "", username: "", password: "", totalStars: 0)
  
  private let userID = "sampleuser_1" // login is not part of MVP, hardcoding this user

  private var userlevels : [UserLevel] = []
  private var feedbacks : [Feedback] = []
  
  // Interface methods
  func getUserID() -> String {
    return self.userID
  }
  
  func getUsername() -> String {
    return self.user.username
  }
  
  func setUsername(_ newUsername : String) -> Void {
    self.user.username = newUsername
  }
  
  func getPassword() -> String {
    return self.user.password
  }
  
  func setPassword(_ newPassword : String) -> Void {
    self.user.password = newPassword
  }
  
  func getTotalStars() -> Int {
    return self.user.totalStars
  }
  
  func setTotalStars(_ newTotal : Int) -> Void {
    self.user.totalStars = newTotal
  }
  
  func getUserLevels(_ sort : String) -> [UserLevel] {
    return self.userlevels
  }
  
  // TODO
  func sortLevels(_ levels : [UserLevel], _ sortBy : String) -> [UserLevel] {
    return []
  }
  
  // TODO
  func filterLevels(_ levels : [UserLevel], _ stars : Int) -> [UserLevel] {
    return []
  }
  
  func getAllFeedback() -> [Feedback] {
    print(self.feedbacks)
    return self.feedbacks
  }
  
  // TODO
  func getFeedback(_ character : String) -> [Feedback] {
    return []
  }
  
  // TODO
//  func attempt(_ character : String, _ image : Image) -> Feedback {
//    return
//  }
  
  func addTotalStars(_ toAdd : Int) -> Int {
    let newTotal = self.user.totalStars + toAdd
    self.user.totalStars = newTotal
    return newTotal
  }
  
  //TODO: When user login set up.
//  func updateUserLevelStars(userID: String, newMaxStars: Int) {
//      // Update the local model
//      if let index = self.userlevels.firstIndex(where: { $0.userlevelID == currentLevelID }) {
//          self.userlevels[index].maxStars = newMaxStars
//      }
//
//      // Update Firebase
//      let userLevelRef = store.collection("userlevel").document(currentLevelID)
//      userLevelRef.updateData(["maxStars": newMaxStars]) { err in
//          if let err = err {
//              print("Error updating maxStars: \(err)")
//          } else {
//              print("maxStars successfully updated")
//          }
//      }
//  }
  
  // Loading data and private helpers
  init() {
    loadUser(self.userID)
    loadUserLevels(self.userID)
    loadFeedbacks(self.userID)
  }
  
  // Loads all user data from Firebase and stores it in self.user
  private func loadUser(_ userID : String) {
    self.store.collection("user").whereField("userID", isEqualTo: userID).limit(to: 1)
      .getDocuments() { (querySnapshot, err) in
        if let err = err {
          print("Error loading current user (\(userID)) from Firebase: \(err).")
        } else {
          let data = querySnapshot?.documents.compactMap { document in
            try? document.data(as: User.self)
          } ?? []
          if(data.count != 1) {
            print("Error loading current user (\(userID)) from Firebase: 0 or multiple users found.")
          } else {
            self.user = data[0]
          }
        }
      }
  }
  
  private func loadUserLevels(_ userID : String) {
    self.store.collection("userlevel").whereField("userID", isEqualTo: userID)
      .getDocuments() { (querySnapshot, err) in
        if let err = err {
          print("Error loading current user (\(userID)) from Firebase: \(err).")
        } else {
          self.userlevels = querySnapshot?.documents.compactMap { document in
            try? document.data(as: UserLevel.self)
          } ?? []
        }
      }
  }
  
  private func loadFeedbacks(_ userID : String) {
    self.store.collection("feedback").whereField("userID", isEqualTo: userID)
      .getDocuments() { (querySnapshot, err) in
        if let err = err {
          print("Error loading current user (\(userID)) from Firebase: \(err).")
        } else {
          self.feedbacks = querySnapshot?.documents.compactMap { document in
            try? document.data(as: Feedback.self)
          } ?? []
        }
      }
  }
  
}
