//
//  TopBarView.swift
//  maobi
//
//  Created by Teresa Yuefan Yang on 11/1/23.
//

import SwiftUI

struct TopBarView: View {
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        ZStack(alignment: .top){
          HStack{
                    Image("star")
                        .foregroundColor(Color(red:1, green: 0.97, blue: 0.78))
                        .frame(width: 43, height: 43)
                        .scaleEffect(0.5)
                    Text("46").bold()

                }
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.9, green: 0.71, blue: 0.54))
            
            

            }
        .overlay(!viewModel.isTabViewEnabled ? Color.black.opacity(0.6).ignoresSafeArea() : nil)

    }
}
