import Foundation
// Added firestore to packages
import Combine
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


struct User: Codable, Hashable {
  @DocumentID var id: String?
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
  @DocumentID var id: String?
  var userID : String
  var userlevelID : String
  var maxStars: Int
  var character: String
  var unlockDate : Date
  
  enum CodingKeys: CodingKey {
    case userID
    case userlevelID
    case maxStars
    case character
    case unlockDate
  }
}

struct Feedback: Codable, Hashable {
  @DocumentID var id: String?
  var feedbackID : String
  var userlevelID : String
  var stars: Int
  var alignment: String
  var strokeOrder : String
  var thickness : String
  var submissionDate : Date
  
  enum CodingKeys: CodingKey {
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
  @Published var allUsers : [User] = []
  @Published var allLevels : [UserLevel] = []
  @Published var allFeedback : [Feedback] = []
  
  init() {
    getAllUsers()
    getAllLevels()
    getAllFeedback()
  }
  
  func getLevelsForUser(_ userID : String, _ levels : [UserLevel]) -> [UserLevel] {
    var result : [UserLevel] = []
    for level in levels {
      if (level.userID == userID) {
        result.append(level)
      }
    }
    return result
  }
  
  
  func getFeedbackForLevel(_ userlevelID : String, _ feedbacks : [Feedback]) -> [Feedback] {
    var result : [Feedback] = []
    for feedback in feedbacks {
      if (feedback.userlevelID == userlevelID) {
        result.append(feedback)
      }
    }
    return result
  }

  
  func getAllUsers() {
    self.store.collection("user")
      .getDocuments() { (querySnapshot, err) in
        if let err = err {
          print("Error getting documents: \(err)")
        } else {
          self.allUsers = querySnapshot?.documents.compactMap { document in
            try? document.data(as: User.self)
          } ?? []
        }
      }
  }
  
  func getAllLevels() {
    self.store.collection("userlevel")
      .getDocuments() { (querySnapshot, err) in
        if let err = err {
          print("Error getting documents: \(err)")
        } else {
          self.allLevels = querySnapshot?.documents.compactMap { document in
            try? document.data(as: UserLevel.self)
          } ?? []
        }
      }
  }
  
  func getAllFeedback() {
    self.store.collection("feedback")
      .getDocuments() { (querySnapshot, err) in
        if let err = err {
          print("Error getting documents: \(err)")
        } else {
          self.allFeedback = querySnapshot?.documents.compactMap { document in
            try? document.data(as: Feedback.self)
          } ?? []
        }
      }
  }
  
  
}
