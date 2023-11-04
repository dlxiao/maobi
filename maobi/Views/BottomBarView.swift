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
        
        TopBarView()

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

            }
    }


//struct BottomBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        BottomBarView()
//    }
//}
