// This file loads user data from Firebase and provides methods to get / set user data

import Foundation
import Combine
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


struct User: Codable, Hashable {
  @DocumentID var userID = UUID().uuidString
  var username : String
  var email : String
  var password : String
  var totalStars : Int
  var completedTutorial : Bool
  var unlocked : [String:Int]
  var dailyChallengeTimestamp : Date
  var dailyChallengeCharacter : String
  
  enum CodingKeys: CodingKey {
    case userID
    case email
    case username
    case password
    case totalStars
    case completedTutorial
    case unlocked
    case dailyChallengeTimestamp
    case dailyChallengeCharacter
  }
}

class UserRepository: ObservableObject {
  let store = Firestore.firestore()
  @Published var userID = ""
  @Published var username = ""
  @Published var email = ""
  @Published var password = ""
  @Published var totalStars = 0
  @Published var completedTutorial = false
  @Published var success = false
  @Published var unlocked : [String:Int] = [:]
  @Published var dailyChallengeTimestamp = Date.now
  @Published var dailyChallengeCharacter = ""
  
  func getTotalStars() -> Int {
    return self.totalStars
  }
  
  func completeTutorial() {
    if(!self.completedTutorial) {
      self.completedTutorial = true
      self.totalStars = 10
      // Update in firebase
      let userRef = self.store.collection("user").document(self.userID)
      userRef.updateData([
        "completedTutorial": true,
        "totalStars": 10
      ])
    }
  }
  
  func unlockLevel(_ cost: Int, _ character : String, _ initialStars : Int) {
    self.totalStars -= cost
    self.unlocked[character] = initialStars
    print("Unlocking level. New stars: \(self.totalStars); New unlocked levels: \(self.unlocked)")
    self.store.collection("user").document(self.userID).updateData([
      "totalStars": self.totalStars,
      "unlocked": self.unlocked
    ])
  }
  
  func saveUserLevel(_ newStars : Int, _ character : String) {
    if let oldStars = unlocked[character] {
      if(oldStars < newStars) {
        self.totalStars += (newStars - oldStars)
        self.unlocked[character] = newStars
        self.store.collection("user").document(self.userID).updateData([
          "totalStars": self.totalStars,
          "unlocked": self.unlocked
        ])
      }
    } else { // must be daily challenge
      unlockLevel(0, character, newStars)
    }
  }
  
  func updateDailyChallenge(_ dailyChallengeTimestamp : Date, _ dailyChallengeCharacter : String) {
    if(!Calendar.current.isDate(dailyChallengeTimestamp, equalTo: Date.now, toGranularity: .day)) {
      print("Changing daily challenge")
      let allCharacters = Levels().getCharacterLevels().map { $0.toString() }
      let locked = allCharacters.filter { self.unlocked[$0] == nil }
      self.dailyChallengeTimestamp = Date.now
      self.dailyChallengeCharacter = locked.randomElement() ?? "八" // in case unlocked all already
      // update firebase
      self.store.collection("user").document(self.userID).updateData([
        "dailyChallengeTimestamp": self.dailyChallengeTimestamp,
        "dailyChallengeCharacter": self.dailyChallengeCharacter
      ])
    } else {
      print("Not changing daily challenge")
      self.dailyChallengeCharacter = dailyChallengeCharacter
      self.dailyChallengeTimestamp = dailyChallengeTimestamp
    }
  }
  
  init(_ username : String, _ password : String, _ email : String = "") {
    self.username = username
    self.password = password
    self.email = email
    
    // Initialize local data
    self.loadUser() { userResult in
      if let user = userResult {
        self.userID = user.userID ?? ""
        self.totalStars = user.totalStars
        self.completedTutorial = user.completedTutorial
        self.unlocked = user.unlocked
        self.success = true
        
        // Update daily challenge
        self.updateDailyChallenge(user.dailyChallengeTimestamp, user.dailyChallengeCharacter)
        
        // Decide if basic strokes need to be unlocked
        // TODO: also unlock "eight" when returning back to home at end of level
        var completedBasicStrokes = true
        for stroke in ["一", "丨", " ` ", "亅", "丶", "丿", "ノ"] {
          if let levelStars = self.unlocked["一"] {
            if(levelStars < 1) {
              completedBasicStrokes = false
            }
          } else {
            completedBasicStrokes = false
          }
        }
        if(completedBasicStrokes) {
          self.unlockLevel(0, "八", 0)
        }
        print("UNLOCKED LEVELS: \(self.unlocked)")
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
  
  func createUser(completion: @escaping ([User]?) -> Void) {
    store.collection("user")
      .whereField("username", isEqualTo: self.username)
      .getDocuments() { (querySnapshot, err) in
        if let err = err {
          print("Error checking if username exists \(self.username)")
          completion([])
        } else {
          let data = querySnapshot?.documents.compactMap { document in
            try? document.data(as: User.self)
          } ?? []
          if(data.count > 0) {
            print("Username already exists: \(self.username)")
            completion(nil)
          } else {
            print("Username doesn't exist, creating account")
            var ref: DocumentReference? = nil
            let emptyDict : [String:Int] = [:]
            ref = self.store.collection("user").addDocument(data: [
              "username": self.username,
              "email": self.email,
              "password": self.password,
              "completedTutorial": false,
              "totalStars": 0,
              "unlocked": emptyDict,
              "dailyChallengeCharacter": "",
              "dailyChallengeTimestamp": Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!
            ]) { err in
              if let err = err {
                print("Error creating user account: \(err)")
              } else {
                print("User account created with ID: \(ref!.documentID)")
                self.userID = ref!.documentID
                self.store.collection("user").document(ref!.documentID).updateData([
                  "userID": ref!.documentID
                ])
                // Retrieve newly created user
                self.store.collection("user")
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
          }
        }
      }
  }
}
