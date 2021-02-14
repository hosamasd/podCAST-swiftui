//
//  DownloadHome.swift
//  podCAST
//
//  Created by hosam on 2/14/21.
//

import SwiftUI

struct DownloadHome: View {
    
    @EnvironmentObject var vmm: MainViewModel
    @StateObject var vm = DownloadViewModel()
    var columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 3)
    
    var body: some View {
        VStack{
            
            HStack(spacing: 15){
                
                Spacer()
                
                Text("Downloads")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                
                Spacer()
                
            }
            .padding(.top,top)
            .padding(.bottom,10)
            .padding(.horizontal)
            
            .zIndex(1)
            
            // Vstack Bug..
            
            //            if vm.notFoundData {
            //                Text("No Download yet!")
            //                    .fontWeight(.semibold)
            //                    .font(.system(size: 18))
            //                    .padding(.top,55)
            //
            //                Spacer()
            //            } else
            if vm.eposdeArray.isEmpty{
                
                if vm.notFoundData {
                    Text("No Download yet!")
                        .fontWeight(.semibold)
                        .font(.system(size: 18))
                        .padding(.top,55)
                    
                    Spacer()
                }
                else {
                    // loading View...
                    ProgressView()
                        .padding(.top,55)
                    
                    Spacer()
                }
            }
            
            
            else {
                
                ScrollView(.vertical, showsIndicators: false, content: {
                    
                    
                    
                    LazyVStack(alignment: .leading, spacing: 0, content: {
                        
                        ForEach(vm.secondEposdeArray) { msg in
                         
                            DownloadView(msg:msg, vmm: vm)
                        }
                    })
                    .padding(.vertical)
                })
                
                
                
            }
            
            
        }
        .navigationBarHidden(true)
        .navigationBarTitle("")
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            self.vm.getDownloads()
        }
    }
}

struct DownloadHome_Previews: PreviewProvider {
    static var previews: some View {
        DownloadHome()
    }
}