//
//  PinnedBookmarkView.swift
//  podCAST
//
//  Created by hosam on 2/14/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct PinnedBookmarkView: View {
    
    @ObservedObject var vmm: MainViewModel
//    @Binding var pinnedView:SecondPodcastModel
     var pinned:SecondPodcastModel
    let name: Namespace.ID
    
    var body: some View {
        WebImage(url: URL(string: pinned.artworkUrl600 ?? "")!)
            .resizable()
            .aspectRatio(contentMode: .fill)
            //padding 30 + spacing 20 = 70
            .frame(width: (UIScreen.main.bounds.width - 70) / 3, height: (UIScreen.main.bounds.width - 70) / 3)
            .clipShape(Circle())
            // context menu for restoring...
            // context menushape...
            .contentShape(Circle())
            .contextMenu{
                
                Button(action: {
                    
                    // removing View...
                    
                    withAnimation(.default){
                        
                        var index = 0
                        
                        for i in 0..<vmm.pinnedViews.count{
                            
                            if pinned.feedUrl == vmm.pinnedViews[i].feedUrl{
                                
                                index = i
                            }
                        }
                        
                        // removing pin view...
                        
                        vmm.pinnedViews.remove(at: index)
                        
                        // adding view to main View....
                        
                        vmm.secondfavoritePodcasts.append(pinned)
                    }
                    
                }) {
                    
                    Text("Remove")
                }
            }
            .matchedGeometryEffect(id: pinned.feedUrl, in: name)
    }
}
