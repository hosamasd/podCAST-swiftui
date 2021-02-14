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
  
    
    @EnvironmentObject var vm:MainViewModel
    @Binding var selected : String

    var body: some View {
        
        HStack{
            
            ForEach(tabs,id: \.self){i in
                
                VStack(spacing: 10){
                    
//                    if self.selected == "Favorite" {
//
//                    Text(vm.showText ?  "New" : "")
//                        .foregroundColor(.green)
//                        .frame(width: 55, height: 5)
//                    }
//                    else if
                    
                    Capsule()
                        .fill(Color.clear)
                        .frame(height: 5)
                        .overlay(


//                            if self.selected == "Favorite" {
                            
//                            ZStack{
                            
                                Capsule()
                                    .fill(self.selected == i ? Color("Color") : Color.clear)
                                    .frame(width: 55, height: 5)
                                
//                                if vm.showText || vm.showTextDownload{
//                                if self.selected == "Favorite" {
//
//                                Text(vm.showText ?  "New" : "asss")
//                                    .foregroundColor(.green)
//                                    .frame(width: 55, height: 5)
//                                }
//                                else if self.selected == "Download"  {
//                                    Text(vm.showTextDownload ?  "New" : "sasas")
//                                        .foregroundColor(.green)
//                                }
//                                }
//                                else {
//                                    Text("")
//                                        .foregroundColor(.green)
//                                }
                                
                           
                                
//                            Capsule()
//                                .fill(self.selected == i ? Color("Color") : Color.clear)
//                                .frame(width: 55, height: 5)


//                            }
//                            .frame(width: 55, height: 5)
                         )
                    
                    Button(action: {
                        
                        self.selected = i
                        
                    }) {
                        
                        VStack{
                            
                            Image(systemName:sss[getName(x:i)])
                                .renderingMode(.original)
                            Text(i)
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            
        }
        .padding(.horizontal)
//        .environmentObject(vm)
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
