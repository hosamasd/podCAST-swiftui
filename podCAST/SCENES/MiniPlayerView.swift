////
////  MiniPlayerView.swift
////  youtube with dummy
////
////  Created by hosam on 2/13/21.
////
//
//import SwiftUI
//
//struct MiniPlayerView: View {
//    
//    @EnvironmentObject var vm : MainViewModel
//    
//    var body: some View {
//        VStack(spacing:0){
//            
//            HStack {
//                VideoPlayerView()
//                    .frame(width:vm.isMiniPlayer ? 150 : vm.width,height:!vm.isMiniPlayer ? getFrame() : 70)
//            }
//            .frame(maxWidth:.infinity,alignment: .leading)
//            .background(VideoControllsView())
//            
//            GeometryReader{reader in
//                
//                ScrollView {
//                    VStack(spacing:18){
//                    
//                    //detail and btn
//                    
//                    VStack(alignment: .leading, spacing: 8, content: {
//                        
//                        Text("hosam mohamed ios developer ")
//                            .font(.callout)
//                        
//                        Text("1.2M views")
//                            .font(.caption)
//                            .fontWeight(.bold)
//                            .foregroundColor(.gray)
//                    })
//                        HStack{
//                            
//                            VideoDetails()
//                            
//                            VideoDetails(image: "hand.thumbsdown", text: "1K")
//                            
//                            VideoDetails(image: "square.and.arrow.up", text: "Share")
//                            
//                            VideoDetails(image: "square.and.arrow.down", text: "Download")
//                            
//                            VideoDetails(image: "message", text: "live chats")
//                        }
//                    
//                        Divider()
//                        
//                        VStack(spacing:15){
//                            
//                            ForEach(videos) {video in
//                                VideoCarView(video: video)
//                                
//                            }
//                        }
//                    }
//                    .padding()
//                }
//                .onAppear(perform: {
//                    vm.height = reader.frame(in: .global).height+250
//                })
//            }
//            .background(Color.white)
//            .opacity(vm.isMiniPlayer ? 0  : getOpacity())
//            .frame(height: vm.isMiniPlayer ? 0 : nil)
//        }
//        .background(Color.white.ignoresSafeArea(.all, edges: .all))
//        .onTapGesture(perform: {
//            self.vm.width=UIScreen.main.bounds.width
//            self.vm.isMiniPlayer.toggle()
//        })
//    }
//    
//    func getOpacity() -> Double {
//        let progress = vm.offset / (vm.height)
//        if progress <= 1 {
//            return Double(1-progress)
//        }
//        
//        return 1
//    }
//    
//    func getFrame() -> CGFloat {
//        let progress = vm.offset/(vm.height-100)
//        
//        if (1-progress) <= 1.0 {
//            let vHeight = (1-progress) * 250
//            
//            if vHeight <= 70 {
//                
//                let precent = vHeight/70
//                let vWidth = precent*UIScreen.main.bounds.width
//                
//                DispatchQueue.main.async {
//                    if vWidth >= 150 {
//                    vm.width=vWidth
//                }
//                }
//                DispatchQueue.main.async {
//                   
//                    vm.width=UIScreen.main.bounds.width
//                }
//                return 70
//            }
//            return vHeight
//            
//        }
//        return 250
//    }
//}
//
//struct VideoDetails: View {
//    var image:String = "hand.thumbsup"
//    var text:String = "123K"
//    
//    var body: some View {
//        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
//            VStack(spacing:8) {
//                
//                Image(systemName: image)
//                
//                Text(text)
//                    .fontWeight(.semibold)
//                    .font(.caption)
//            }
//        })
//        .foregroundColor(.black)
//        .frame(maxWidth:.infinity)
//    }
//}
