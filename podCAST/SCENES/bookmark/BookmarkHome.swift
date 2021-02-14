//
//  BookmarkHome.swift
//  podCAST
//
//  Created by hosam on 2/14/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct BookmarkHome: View {
    
    @StateObject var vmm = MainViewModel()
    var columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 3)
    @Namespace var name
    
    var body: some View {
        VStack{
            
            HStack(spacing: 15){
                
                Spacer()
                
                Text("Favorites")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                
                Spacer()
                
            }
            .padding(.top,top)
            .padding(.bottom,10)
            .padding(.horizontal)
            
            .zIndex(1)
            
            // Vstack Bug..
            
            if vmm.notFoundData {
                Text("No search artist done before!")
                    .fontWeight(.semibold)
                    .font(.system(size: 18))
                    .padding(.top,55)
                
                Spacer()
            } else  if vmm.secondfavoritePodcasts.isEmpty{
                
                // loading View...
                ProgressView()
                    .padding(.top,55)
                
                Spacer()
            }
            
            else {
                
                ScrollView(.vertical, showsIndicators: false, content: {
                    
                    // Pinned View...
                    
                    if !vmm.pinnedViews.isEmpty{
                        //
                        LazyVGrid(columns: columns,spacing: 20){
                            
                            ForEach(vmm.pinnedViews,id:\.feedUrl){pinned in
                                let v = PodcastModel(artistName: pinned.artistName, trackName: pinned.trackName, artworkUrl600: pinned.artworkUrl600, trackCount: pinned.trackCount, feedUrl: pinned.feedUrl)
                                
                                NavigationLink(destination: PodcastDetail(podcast:v)) {
                                PinnedBookmarkView(vmm:vmm,pinned:pinned,name:name)
                                }
                            }
                        }
                        .padding()
                    }
                    
                    LazyVStack(alignment: .leading, spacing: 0, content: {
                        
                        ForEach(vmm.secondfavoritePodcasts,id:\.feedUrl) { msg in
                            let v = PodcastModel(artistName: msg.artistName, trackName: msg.trackName, artworkUrl600: msg.artworkUrl600, trackCount: msg.trackCount, feedUrl: msg.feedUrl)
                            
                            NavigationLink(destination: PodcastDetail(podcast:v)) {
                            BookmarkView(vmm:vmm,msg:msg,name:name)
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
            self.vmm.getFavorites()
        }
    }
    
    func getIndex(profile: String)->Int{
        
        var index = 0
        
        for i in 0..<vmm.secondfavoritePodcasts.count{
            
            if profile == vmm.secondfavoritePodcasts[i].feedUrl{
                
                index = i
            }
        }
        
        return index
    }
}

struct BookmarkHome_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkHome()
    }
}
