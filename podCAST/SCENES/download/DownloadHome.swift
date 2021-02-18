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
                            let xxx = EpoisdesModel(title: msg.title, pubDate: msg.pubDate, description: msg.description,imageUrl:msg.imageUrl, author: msg.author, streamUrl: msg.streamUrl,fileUrl:msg.fileUrl)
                            
                            DownloadView(msg:msg, vmm: vm)
                                .onTapGesture {
                                    withAnimation{
                                        self.vmm.handleDownloadTap(epo: xxx)

                                    }
                                }

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
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.downloadProgress))
               { obj in
            
                  // Change key as per your "userInfo"
                   if let userInfo = obj.userInfo as? [String : Any] {
//                     print(info)
                    self.vm.handleDownloadProgress(userInfo: userInfo )
                  }
            
        }
        
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.downloadComplete))
               { obj in
                  // Change key as per your "userInfo"
            if let userInfo = obj.userInfo as? [String : Any] {
//                    self.vm.handleDownloadComplete(userInfo: userInfo)
                self.vmm.handleDownloadComplete(userInfo: userInfo)
                  }
            
        }
        .alert(isPresented: $vmm.alert) {
            
            Alert(title: Text("Item not found"), message: Text(self.vmm.alertMsg), primaryButton: .default(Text("OK"), action: {
                self.vmm.handlePlay(epo: self.vmm.podcastAlert)
            }), secondaryButton: .cancel())
        }
    }
}

struct DownloadHome_Previews: PreviewProvider {
    static var previews: some View {
        DownloadHome()
    }
}
