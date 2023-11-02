//
//  TopBarView.swift
//  maobi
//
//  Created by Teresa Yuefan Yang on 11/1/23.
//

import SwiftUI

struct TopBarView: View {
    @State var isMenuOpen = false
    var body: some View {
        VStack{
            HStack{
                Button(action:{withAnimation{
                    isMenuOpen.toggle()
                }
                    
                }) {
                    Image(systemName: isMenuOpen ? "xmark" : "line.horizontal.3")
                        .font(.title)
                        .foregroundColor(.black)
                }
                Spacer()
                
                Image(systemName: "star.fill")
                    .foregroundColor(Color.yellow)
                    .frame(width: 43, height: 43)
                    .scaleEffect(1.5)
                Text("46").bold()
                
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(red: 0.9, green: 0.71, blue: 0.54))
            Spacer()
        }


    }
}

struct TopBarView_Previews: PreviewProvider {
    static var previews: some View {
        TopBarView()
    }
}
