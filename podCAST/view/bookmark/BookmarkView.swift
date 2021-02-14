//
//  BookmarkView.swift
//  podCAST
//
//  Created by hosam on 2/14/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct BookmarkView: View {
    
    
    @ObservedObject var vmm: MainViewModel
//    @Binding var pinnedView:SecondPodcastModel
     var msg:SecondPodcastModel
    let name: Namespace.ID
    
    var body: some View {
        
      ZStack  {
            //
            //                                // adding Buttons...
            //
            HStack{
                
                Color.yellow
                    .frame(width: 90)
                    // hiding when left swipe...
                    .opacity(msg.offset > 0 ? 1 : 0)
                
                Spacer()
                
                Color.red
                    .frame(width: 90)
                    .opacity(msg.offset < 0 ? 1 : 0)
            }
            //
            HStack{
                //
                Button(action: {
                    
                    // appending View....
                    withAnimation(.default){
                        
                        
                        let index = getIndex(profile: msg.feedUrl ?? "")
                        
                        var pinnedView = vmm.secondfavoritePodcasts[index]
                        
                        // setting offset to 0
                        
                        pinnedView.offset = 0
                        
                        vmm.pinnedViews.append(pinnedView)
                        
                        // removing from main View...
                        
                        vmm.secondfavoritePodcasts.removeAll { (msg1) -> Bool in
                            
                            if msg.feedUrl == msg1.feedUrl{return true}
                            else{return false}
                        }
                    }
                    
                }, label: {
                    
                    Image(systemName: "pin.fill")
                        .font(.title)
                        .foregroundColor(.white)
                })
                .frame(width: 90)
                //
                //                                    // on ended not working...
                //
                Spacer()
                
                Button(action: {
                    
                    // removing from main View...
                    
                    withAnimation(.default){
                        
                        self.vmm.removeFavorites(msg: msg)
                    }
                    
                }, label: {
                    
                    Image(systemName: "trash.fill")
                        .font(.title)
                        .foregroundColor(.white)
                })
                .frame(width: 90)
            }
            //
            HStack(spacing: 15){
                
                WebImage(url: URL(string: msg.artworkUrl600 ?? "")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .matchedGeometryEffect(id: msg.feedUrl, in: name)
                
                VStack(alignment: .leading,spacing: 10){
                    
                    Text(msg.artistName ?? "")
                    
                    Text(msg.trackName ?? "")
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    
                    Divider()
                }
            }
            .padding(.all)
            .background(Color.white)
            .contentShape(Rectangle())
            // adding gesture...
            .offset(x: msg.offset)
            .gesture(DragGesture().onChanged({ (value) in
                //
                withAnimation(.default){
                    
                    vmm.secondfavoritePodcasts[getIndex(profile: msg.feedUrl ?? "")].offset = value.translation.width
                }
                
            })
            .onEnded({ (value) in
                
                withAnimation(.default){
                    
                    if value.translation.width > 80{
                        
                        vmm.secondfavoritePodcasts[getIndex(profile: msg.feedUrl ?? "")].offset = 90
                    }
                    else if value.translation.width < -80{
                        
                        vmm.secondfavoritePodcasts[getIndex(profile: msg.feedUrl ?? "")].offset = -90
                    }
                    else{
                        
                        vmm.secondfavoritePodcasts[getIndex(profile: msg.feedUrl ?? "")].offset = 0
                    }
                }
            }))
            //
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

