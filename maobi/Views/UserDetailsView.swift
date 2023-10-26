import SwiftUI

struct UserDetailsView: View {
  var levels : [UserLevel]
  var userRepository : UserRepository
  var feedbacks : [Feedback]
  
  var body: some View {
    NavigationView {
      List {
        ForEach(levels, id: \.self) { level in
          let currFeedback = userRepository.getFeedbackForLevel(level.userlevelID, feedbacks)
          let dateFormatter = DateFormatter()
          
          VStack(alignment: .leading) {
            Text("Level Data: ").font(Font.headline.weight(.bold))
            Text(" ")
            Text("Level ID: " + level.userlevelID)
            Text("Character: " + level.character)
            Text("Max Stars: " + String(level.maxStars))
            Text("Unlock Date:" + dateFormatter.string(from: level.unlockDate))
            Text(" ")
            Text("Attempts' Feedback: ").font(Font.headline.weight(.bold))
            Text(" ")
            ForEach(feedbacks, id: \.self) {feedback in
              VStack(alignment: .leading) {
                Text("> ID: " + feedback.feedbackID)
                Text("> Thickness: " + feedback.thickness)
                Text("> Alignment: " + feedback.alignment)
                Text("> Stroke Order: " + feedback.strokeOrder)
                Text("> Stars: " + String(feedback.stars))
                Text("> Date: " + dateFormatter.string(from: feedback.submissionDate))
                Text(" ")
              }
            }
          }
        }
      }
    }.navigationBarTitle("Levels for User")
  }
  
  
}
