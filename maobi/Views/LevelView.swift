//
//  LevelView.swift
//  maobi
//
//  Created by Dora Xiao on 10/31/23.
//

import SwiftUI

struct LevelView: View {
  var character : CharacterData
  var body: some View {
    Text(character.toString())
    Text(character.getDefinition())
    Text(character.getPinyin())
    // add proper spacing
    LevelGraphicsView(html: "<p>level graphics view</p>") // pass in image and animation
    NavigationLink( // replace this with "Practice Now" button that goes to camera view
      destination: LevelView(character: character),
      label: {Text(character.toString())
      })
  }
}
