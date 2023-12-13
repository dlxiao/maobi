//
//  TestView.swift
//  maobi
//
//  Created by Dora Xiao on 12/12/23.
//

import SwiftUI

struct TestView: View {
  @EnvironmentObject var opData : OpData
  var body: some View {
    Text("Test View")
    Button(action: {
      opData.character = opData.levels.getCharacter("小")
      opData.cameraModel.storeOrigImage(UIImage(named: "小_thick")!)
      opData.currView = .alignment
    }) {
      Text("Go to alignment")
    }
  }
}
