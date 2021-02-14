//
//  CustomTabView.swift
//  grocery swiftui
//
//  Created by hosam on 1/12/21.
//

import SwiftUI

struct CustomTabView: View {
    var tabs = ["Search","Favorite","Download"]

    var sss = ["viewfinder","book.circle.fill","square.and.arrow.down.on.square.fill"]
  
    
    
    @Binding var selected : String

    var body: some View {
        
        HStack{
            
            ForEach(tabs,id: \.self){i in
                
                VStack(spacing: 10){
                    
                    Capsule()
                        .fill(Color.clear)
                        .frame(height: 5)
                        .overlay(
                    
                            Capsule()
                                .fill(self.selected == i ? Color("Color") : Color.clear)
                                .frame(width: 55, height: 5)
                         )
                    
                    Button(action: {
                        
                        self.selected = i
                        
                    }) {
                        
                        VStack{
                            
                            Image(systemName:sss[getName(x:i)])
//                            Image(i)
                                .renderingMode(.original)
                            Text(i)
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            
        }
        .padding(.horizontal)
    }
    
    func getName(x:String) -> Int {
        return x == "Search" ? 0 : x == "Favorite" ? 1 : 2
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
