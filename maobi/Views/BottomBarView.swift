//
//  BottomBarView.swift
//  maobi
//
//  Created by Teresa Yuefan Yang on 11/3/23.
//

import SwiftUI

struct BottomBarView: View {
    var levels: Levels

    var body: some View {
                            
//            if isMenuOpen{
//                MenuView(levels: levels)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//            }
                
                
                TabView{
                    HomeView(levels: levels)
                        .tabItem{
                            Image(systemName: "house.fill")
                                .foregroundColor(Color.black)
                        }
                    
                    MenuView(levels: levels)
                        .tabItem{
                            Image(systemName:"person.fill")
                                .foregroundColor(Color.black)
                        }


                }
                .background(Color(red: 0.9, green: 0.71, blue: 0.54))
                

            }
    }


//struct BottomBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        BottomBarView()
//    }
//}
