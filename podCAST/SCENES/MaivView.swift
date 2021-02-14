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
    @StateObject var vmm = MainViewModel()
    
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom), content: {
            
            NavigationView{
                
                
                VStack{
                    
                    if self.selected == "Search"{
                        
                        Home()
                    }
                    else if self.selected == "Favorite"{
                        VStack {
                            Spacer()
                            Text("dfdsfdsf")
                            Spacer()
                        }
                    }
                    else{
                        VStack {
                            Spacer()
                            Text("dfdsfdsf")
                            Spacer()
                        }
                    }
                    
                    CustomTabView(selected: $selected)
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                
            }
            
            if vmm.show {
                
                
                SecondMiniplayer(animation: animation, expand: $vmm.show)
                
            }
        })
    }
}

struct MaivView_Previews: PreviewProvider {
    static var previews: some View {
        MaivView()
    }
}
