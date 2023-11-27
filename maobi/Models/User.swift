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
  
  enum CodingKeys: CodingKey {
    case userID
    case email
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
  @Published var email = ""
  @Published var password = ""
  @Published var totalStars = 0
  @Published var completedTutorial = false
  @Published var success = false
  
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
      ]) { err in
        if let err = err {
          print("Error completing tutorial: \(err).")
        } else {
          print("Tutorial completed.")
        }
      }
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
            ref = self.store.collection("user").addDocument(data: [
              "username": self.username,
              "email": self.email,
              "password": self.password,
              "completedTutorial": false,
              "totalStars": 0,
            ]) { err in
              if let err = err {
                print("Error creating user account: \(err)")
              } else {
                print("User account created with ID: \(ref!.documentID)")
                self.userID = ref!.documentID
                self.store.collection("user").document(ref!.documentID).updateData([
                  "userID": ref!.documentID
                ]) { err in
                  if let err = err {
                    print("Error updating userID: \(err)")
                  } else {
                    print("Document successfully updated")
                  }
                }
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
