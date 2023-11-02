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
                    .foregroundColor(Color(red:1, green: 0.97, blue: 0.78))
                    .frame(width: 43, height: 43)
                    .scaleEffect(1.5)
                Text("46").bold()
                
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(red: 0.9, green: 0.71, blue: 0.54))
            Spacer()
            
            if isMenuOpen{
                MenuView()
                    .frame(width: 250)
                    .background(Color.white)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isMenuOpen.toggle()
                    }
            }
        }


    }
}

struct TopBarView_Previews: PreviewProvider {
    static var previews: some View {
        TopBarView()
    }
}
