//
//  MaivView.swift
//  podCAST
//
//  Created by hosam on 2/14/21.
//

import SwiftUI

struct MaivView: View {
    @State var selected = "Search"
    @Namespace var animation
    @State var expand = false
//    @StateObject var vmm = MainViewModel()
    @EnvironmentObject var vmm : MainViewModel
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom), content: {
            
            NavigationView{
                
                
                VStack{
                    
                   
                     if self.selected == "Favorite"{
                       BookmarkHome()
                    }
                    
                     else  if self.selected == "Search"{
                        
                        Home()
                    }
                    else{
                        DownloadHome()
                    }
                    
                    CustomTabView(selected: $selected)
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                
            }
            
            if vmm.show {
                
//                SecondMiniplayer()
                
//                SSSecondMiniplayer(animation: animation)
                SecondMiniplayer(animation: animation)
                    .padding(.bottom,vmm.expand ? 0 : 20)
                
            }
        })
    }
}

struct MaivView_Previews: PreviewProvider {
    static var previews: some View {
        MaivView()
    }
}
