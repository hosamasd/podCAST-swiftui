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
                                
                                PinnedBookmarkView(vmm:vmm,pinned:pinned,name:name)
                                
                                //                        TopView(pinned:pinned,pinnedViews:$pinnedViews,messages:$messages)
                                
                                
//                                WebImage(url: URL(string: pinned.artworkUrl600 ?? "")!)
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    //padding 30 + spacing 20 = 70
//                                    .frame(width: (UIScreen.main.bounds.width - 70) / 3, height: (UIScreen.main.bounds.width - 70) / 3)
//                                    .clipShape(Circle())
//                                    // context menu for restoring...
//                                    // context menushape...
//                                    .contentShape(Circle())
//                                    .contextMenu{
//
//                                        Button(action: {
//
//                                            // removing View...
//
//                                            withAnimation(.default){
//
//                                                var index = 0
//
//                                                for i in 0..<vmm.pinnedViews.count{
//
//                                                    if pinned.feedUrl == vmm.pinnedViews[i].feedUrl{
//
//                                                        index = i
//                                                    }
//                                                }
//
//                                                // removing pin view...
//
//                                                vmm.pinnedViews.remove(at: index)
//
//                                                // adding view to main View....
//
//                                                vmm.secondfavoritePodcasts.append(pinned)
//                                            }
//
//                                        }) {
//
//                                            Text("Remove")
//                                        }
//                                    }
//                                    .matchedGeometryEffect(id: pinned.feedUrl, in: name)
                            }
                        }
                        .padding()
                    }
                    
                    LazyVStack(alignment: .leading, spacing: 0, content: {
                        
                        ForEach(vmm.secondfavoritePodcasts,id:\.feedUrl) { msg in
                            
                            BookmarkView(vmm:vmm,msg:msg,name:name)
//                            ZStack {
//                                //
//                                //                                // adding Buttons...
//                                //
//                                HStack{
//
//                                    Color.yellow
//                                        .frame(width: 90)
//                                        // hiding when left swipe...
//                                        .opacity(msg.offset > 0 ? 1 : 0)
//
//                                    Spacer()
//
//                                    Color.red
//                                        .frame(width: 90)
//                                        .opacity(msg.offset < 0 ? 1 : 0)
//                                }
//                                //
//                                HStack{
//                                    //
//                                    Button(action: {
//
//                                        // appending View....
//                                        withAnimation(.default){
//
//
//                                            let index = getIndex(profile: msg.feedUrl ?? "")
//
//                                            var pinnedView = vmm.secondfavoritePodcasts[index]
//
//                                            // setting offset to 0
//
//                                            pinnedView.offset = 0
//
//                                            vmm.pinnedViews.append(pinnedView)
//
//                                            // removing from main View...
//
//                                            vmm.secondfavoritePodcasts.removeAll { (msg1) -> Bool in
//
//                                                if msg.feedUrl == msg1.feedUrl{return true}
//                                                else{return false}
//                                            }
//                                        }
//
//                                    }, label: {
//
//                                        Image(systemName: "pin.fill")
//                                            .font(.title)
//                                            .foregroundColor(.white)
//                                    })
//                                    .frame(width: 90)
//                                    //
//                                    //                                    // on ended not working...
//                                    //
//                                    Spacer()
//
//                                    Button(action: {
//
//                                        // removing from main View...
//
//                                        withAnimation(.default){
//
//                                            self.vmm.removeFavorites(msg: msg)
//                                        }
//
//                                    }, label: {
//
//                                        Image(systemName: "trash.fill")
//                                            .font(.title)
//                                            .foregroundColor(.white)
//                                    })
//                                    .frame(width: 90)
//                                }
//                                //
//                                HStack(spacing: 15){
//
//                                    WebImage(url: URL(string: msg.artworkUrl600 ?? "")!)
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fill)
//                                        .frame(width: 60, height: 60)
//                                        .clipShape(Circle())
//                                        .matchedGeometryEffect(id: msg.feedUrl, in: name)
//
//                                    VStack(alignment: .leading,spacing: 10){
//
//                                        Text(msg.artistName ?? "")
//
//                                        Text(msg.trackName ?? "")
//                                            .foregroundColor(.gray)
//                                            .lineLimit(1)
//
//                                        Divider()
//                                    }
//                                }
//                                .padding(.all)
//                                .background(Color.white)
//                                .contentShape(Rectangle())
//                                // adding gesture...
//                                .offset(x: msg.offset)
//                                .gesture(DragGesture().onChanged({ (value) in
//                                    //
//                                    withAnimation(.default){
//
//                                        vmm.secondfavoritePodcasts[getIndex(profile: msg.feedUrl ?? "")].offset = value.translation.width
//                                    }
//
//                                })
//                                .onEnded({ (value) in
//
//                                    withAnimation(.default){
//
//                                        if value.translation.width > 80{
//
//                                            vmm.secondfavoritePodcasts[getIndex(profile: msg.feedUrl ?? "")].offset = 90
//                                        }
//                                        else if value.translation.width < -80{
//
//                                            vmm.secondfavoritePodcasts[getIndex(profile: msg.feedUrl ?? "")].offset = -90
//                                        }
//                                        else{
//
//                                            vmm.secondfavoritePodcasts[getIndex(profile: msg.feedUrl ?? "")].offset = 0
//                                        }
//                                    }
//                                }))
//                                //
//                            }
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
