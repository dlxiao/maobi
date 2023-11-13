//
//  ViewModel.swift
//  maobi
//
//  Created by Teresa Yuefan Yang on 11/7/23.
//

import SwiftUI
import Combine

class ViewModel: ObservableObject {
    @Published var isTabViewEnabled: Bool = true
    @Published var menuView: Bool = false
    @Published var isOnboardingEnabled: Bool = false
    }

//struct ViewModel_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewModel()
//    }
//}
