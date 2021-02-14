//
//  SecondMiniplayer.swift
//  vm.selectedPodacst
//
//  Created by hosam on 2/14/21.
//

import SwiftUI
import SDWebImageSwiftUI
import AVKit

struct SecondMiniplayer: View {
    
    var animation: Namespace.ID
    @Binding var expand : Bool
    var height = (UIScreen.main.bounds.height)/3
//     var vm.selectedPodacst :EpoisdesModel
    @State var audioPlayer: AVAudioPlayer!
    @State var isPlaying : Bool = false
    //safeArea
    var safeArea = UIApplication.shared.windows.first?.safeAreaInsets
    //volume slider
    @State var slider:CGFloat = 0
    //gesture offset
    @State var offset:CGFloat = 0
    @GestureState var gestureOffset:CGFloat = 0 //avoid glitches
    @EnvironmentObject var vm:MainViewModel
    
    var body: some View {
        VStack {
            
            Capsule()
                .fill(Color.gray)
                .frame(width: vm.show ? 60 : 0, height: vm.show ? 4 : 0)
                .opacity(vm.show ? 1 : 0)
                .padding(.top,vm.show ? safeArea?.top : 0)
                .padding(.vertical,vm.show ? 30 : 0)
            
            HStack(spacing:15){
                
                //center image
                if expand{Spacer(minLength: 0)}
                
//                if vm.selectedPodacst.imageUrl != nil {
//                    Image(systemName: "home")
////                    WebImage(url: URL(string: vm.selectedPodacst.imageUrl!)!)
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: vm.show ? height :  55, height: vm.show ? height : 55)
//
//                    if !vm.show{
//                        Text(vm.selectedPodacst.title ?? "not found")
//                            .font(.title2)
//                            .fontWeight(.bold)
//                            .matchedGeometryEffect(id: "Label", in: animation)
//                    }
//
//                    Spacer(minLength: 0)
//
//                    if !vm.show {
//                        Button(action: {
//                            self.audioPlayer.play()
//                        }, label: {
//                            Image(systemName: "play.fill")
//                                .font(.title2)
//                                .foregroundColor(.primary)
//                        })
//
//                        Button(action: {
//
//                        }, label: {
//                            Image(systemName: "forward.fill")
//                                .font(.title2)
//                                .foregroundColor(.primary)
//                        })
//                    }
//
//                }
//                else {
                
               Image(systemName: "home")
//                    WebImage(url: URL(string: vm.selectedPodacst.imageUrl!)!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: vm.show ? height :  55, height: vm.show ? height : 55)
                
                if !expand{
                    Text(vm.selectedPodacst.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .matchedGeometryEffect(id: "Label", in: animation)
                }
                
                Spacer(minLength: 0)
                
                if !vm.show {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "play.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    })
                    
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "forward.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    })
                }
                
//            }
            }
            .padding(.horizontal)
            
            VStack(spacing: 15){
                
                Spacer(minLength: 0)
                
                
                
                HStack{
                    
                    if vm.show{
                        
                        Text(vm.selectedPodacst.title ?? "not found")
                            .font(.title2)
                            .foregroundColor(.primary)
                            .fontWeight(.bold)
                            .matchedGeometryEffect(id: "Label", in: animation)
                    }
                    
                    Spacer(minLength: 0)
                    
                    Button(action: {}) {
                        
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
                
                .padding()
                .padding(.top,20)
                //live string
                
                HStack {
                    Capsule()
                        .fill(
                            LinearGradient(gradient: .init(colors: [Color.primary.opacity(0.7),Color.primary.opacity(0.1)]), startPoint: .leading, endPoint: .trailing)
                        )
                        .frame( height: 4)
                    
                    Text(vm.selectedPodacst.author)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Capsule()
                        .fill(
                            LinearGradient(gradient: .init(colors: [Color.primary.opacity(0.1),Color.primary.opacity(0.7)]), startPoint: .leading, endPoint: .trailing)
                        )
                        .frame( height: 4)
                }
                .padding()
                
                //stop btn
                
                Button(action: {}, label: {
                    Image(systemName: "stop.fill")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                })
                .padding()
                
                Spacer(minLength: 0)
                
                HStack(spacing:15) {
                    Image(systemName: "speaker.fill")
                    
                    Slider(value:$slider)
                    
                    Image(systemName: "speaker.wave.2.fill")
                }
                .padding()
                
                HStack (spacing:15) {
                    
                    Button(action: {}, label: {
                        Image(systemName: "arrow.up.message")
                            .font(.title2)
                            .foregroundColor(.primary)
                    })
                    
                    Button(action: {}, label: {
                        Image(systemName: "airplayaudio")
                            .font(.title2)
                            .foregroundColor(.primary)
                    })
                    
                    Button(action: {}, label: {
                        Image(systemName: "list.bullet")
                            .font(.title2)
                            .foregroundColor(.primary)
                    })
                    
                    
                }
                .padding(.bottom,safeArea?.bottom == 0 ? 15 : safeArea?.bottom)
            }
            .frame( height:vm.show ? nil : 0)
            .opacity(vm.show ? 1 : 0)
        }
//        .opacity(vm.selectedPodacst.artistName == nil ? 0 : 1)
        .frame(maxHeight: vm.show ? .infinity : 80)
        
        .background(
            VStack(spacing:0) {
                BlurView()
                
                Divider()
            }
            
            .onTapGesture(perform: {
                withAnimation(.spring()) {vm.show=true}
            })
            
        )
        .cornerRadius(vm.show ? 20 : 0)
        .offset(y: vm.show ? 0 : -48)
        .offset(y: offset)
        gesture(DragGesture().updating($gestureOffset, body: { (value, state, _) in
            state=value.translation.height
        }).onEnded(onEnded))
        .onChange(of: gestureOffset, perform: { value in
            onChanged()
        })
//        .gesture(DragGesture().onEnded(onended(value:)).onChanged(onchanged(value:)))
        .ignoresSafeArea()
        
        .onAppear {
            audioPlayer = AVAudioPlayer()
//            let sound = Bundle.main.path(forResource: "rain-03", ofType: "mp3")
//            self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
           
        }
    }
    
    func onChanged()  {
        if gestureOffset > 0 && !vm.isMiniPlayer && vm.offset+70<=vm.height {
         
        vm.offset=gestureOffset
        }
    }
    
//    func onChanged(value:DragGesture.Value)  {
//        //when only vm.show
//        if value.translation.height > 0 && vm.show {
//            offset = value.translation.height
//        }
//    }
    
    func onEnded(value:DragGesture.Value)  {
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.95, blendDuration: 0.95 )){
            
            if value.translation.height > height {
                vm.show = false
            }
            
            offset = 0
        }
    }
    
    func playAudio()  {
//        guard let url = URL.init(string: vm.selectedPodacst.) else { return }
//                let playerItem = AVPlayerItem.init(url: url)
//                player = AVPlayer.init(playerItem: playerItem)
//                player?.play()
//                startNowPlayingAnimation(true)
//                played = true
    }
}

