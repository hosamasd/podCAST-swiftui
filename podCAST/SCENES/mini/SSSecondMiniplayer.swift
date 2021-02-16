//
//  SSSecondMiniplayer.swift
//  podCAST
//
//  Created by hosam on 2/16/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct SSSecondMiniplayer: View {
    
    var animation: Namespace.ID
    //    @Binding var expand : Bool
    var height = (UIScreen.main.bounds.height)/3
    //     var vm.selectedPodacst :EpoisdesModel
    //    @State var audioPlayer: AVAudioPlayer!
    @State var isPlaying : Bool = false
    //safeArea
    var safeArea = UIApplication.shared.windows.first?.safeAreaInsets
    //volume slider
    @State var slider:CGFloat = 0
    //gesture offset
    @State var offset:CGFloat = 0
    @GestureState var gestureOffset:CGFloat = 0 //avoid glitches
    @EnvironmentObject var vm:MainViewModel
    
//    @State var width : CGFloat = UIScreen.main.bounds.height < 750 ? 130 : 230
    // For Smaller Size Phones
    @State var width : CGFloat = UIScreen.main.bounds.height < 750 ? 130 : 230
    @State var timer = Timer.publish(every: 0.5, on: .current, in: .default).autoconnect()
    
    var body: some View {
        VStack {
          
            Capsule()
                .fill(Color.gray)
                .frame(width: vm.expand ? 60 : 0, height: vm.expand ? 4 : 0)
                .opacity(vm.expand ? 1 : 0)
                .padding(.top,vm.expand ? safeArea?.top : 0)
                .padding(.vertical,vm.expand ? 30 : 0)
            
            HStack(spacing:15){
                
                //center image
                if vm.expand{Spacer(minLength: 0)}
                
                
                ZStack{
                
                WebImage(url: URL(string: vm.selectedPodacst.imageUrl ?? ""))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: vm.expand ? width : 55, height: vm.expand ? width : 55)
                    .clipShape(Circle())
                    .scaleEffect(x:vm.epoOffset,y: vm.epoOffset)
//                    .frame(width: vm.expand ? height :  55, height: vm.expand ? height : 55)
//                    .cornerRadius(15)
//                    .scaleEffect(x: vm.epoOffset, y: vm.epoOffset)
                
                    if vm.expand {
                        
                        ZStack{
                            
                            // SLider...
                            Circle()
                                .trim(from: 0, to: 0.8)
                                .stroke(Color.black.opacity(0.06),lineWidth: 4)
                                .frame(width: width + 45, height: width + 45)
                            
                            Circle()
                                .trim(from: 0, to: CGFloat(vm.angle) / 360)
                                .stroke(Color("orange"),lineWidth: 4)
                                .frame(width: width + 45, height: width + 45)
                            
                            // Slider Circle...
                            
                            Circle()
                                .fill(Color("orange"))
                                .frame(width: 25, height: 25)
                                // Moving View...
                                .offset(x: (width + 45) / 2)
                                .rotationEffect(.init(degrees: vm.angle))
                            // gesture...
                                .gesture(DragGesture().onChanged(vm.onChanged(value:)))
                            
                            
                        }
                        // Rotating View For Bottom Facing...
                        // Mid 90 deg + 0.1*360 = 36
                        // total 126
                        .rotationEffect(.init(degrees: 126))
                        
                        // Time Texts....
                        
                        Text(vm.currentTimeAvAudio)//vm.getCurrentTime(value: vm.player.currentTime))
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .offset(x: UIScreen.main.bounds.height < 750 ? -65 : -85 , y: (width + 70) / 2)
                        
                        Text(vm.totalTimeAvAudio)//vm.getCurrentTime(value: vm.player.duration))
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .offset(x: UIScreen.main.bounds.height < 750 ? 65 : 85 , y: (width + 70) / 2)
                    }
                    
                }
                
                if !vm.expand{
                    Text(vm.selectedPodacst.title )
                        .font(.title2)
                        .fontWeight(.bold)
                        .matchedGeometryEffect(id: "Label", in: animation)
                }
                
                Spacer(minLength: 0)
                
                if !vm.expand {
                    Button(action: {
                        withAnimation{
                            vm.play()
                        }
                        //                        self.audioPlayer.play()
                    }, label: {
                        Image(systemName: vm.isPlaying ? "stop.fill" : "play.fill")
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
                
            }
            .padding(.horizontal)
            
            VStack(spacing: 15){
                
                Spacer(minLength: 0)
                
                
                
                HStack{
                    
                    if vm.expand{
                        
                        Text(vm.selectedPodacst.title )
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
                    
                    Text(vm.checkAuthor())
                        .fontWeight(.bold)
                        .foregroundColor(vm.selectedPodacst.author != "" ? .primary : .green)
                    
                    Capsule()
                        .fill(
                            LinearGradient(gradient: .init(colors: [Color.primary.opacity(0.1),Color.primary.opacity(0.7)]), startPoint: .leading, endPoint: .trailing)
                        )
                        .frame( height: 4)
                }
                .padding()
                
                //stop btn
                
                Button(action: {
                    withAnimation{
                        vm.play()
                    }
                }, label: {
                    Image(systemName: vm.isPlaying ? "stop.fill" : "play.fill")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                })
                .padding()
                
                Spacer(minLength: 0)
                
                // Timings...
                
//                HStack{
//
//                    Text(vm.epopCurrentTimeValue)
//                        .font(.caption2)
//                        .foregroundColor(.black)
//
//                    Spacer()
//
//                    Text(vm.epopTotalTimeValue)
//                        .font(.caption2)
//                        .foregroundColor(.black)
//                }
//                .padding(.horizontal)
////                .padding(.top, 25)
//
//                ZStack(alignment: Alignment(horizontal: .leading, vertical: .center), content: {
//
//                    Capsule()
//                        .fill(Color.gray.opacity(0.2))
//                        .frame(height: 6)
//
//                    ZStack(alignment: Alignment(horizontal: .trailing, vertical: .center)) {
//
//                        Capsule()
//                            .fill(Color("Color1").opacity(0.6))
//                            .frame(width: vm.epovTimeValue,height: 6)
//
//                        // Drag Button....
//
//                        Circle()
//                            .fill(Color("Color1").opacity(0.7))
//                            .frame(width: 10, height: 10)
//                            .padding(.all, 10)
//                            .background(Color("Color"))
//                            .clipShape(Circle())
//                        // adding shadow...
//                            .shadow(color: Color("Color1").opacity(0.6),radius: 10,x: 4,y: 2)
//                    }
//                })
//
//
//
//                // adding gesture..
//                .gesture(DragGesture().onChanged(vm.trackSliderTimer))
//                .padding(.horizontal)
//                .padding(.top, 8)
                
                Spacer(minLength: 0)
                
                HStack (spacing:15) {
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation{
                            vm.seekToCurrentTimes(delta: -15)
                        }
                    }, label: {
                        Image(systemName: "goforward.15")
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                    })
                    
                    Button(action: {
                        withAnimation{
                            vm.seekToCurrentTimes(delta: 15)
                        }
                    }, label: {
                        Image(systemName: "gobackward.15")
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                    })
                    
                    Spacer()
                    
                    
                }
                
                HStack(spacing:15) {
                    Image(systemName: "speaker.fill")
                    
                    ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
                        
                        Capsule()
                            .fill(Color.black.opacity(0.06))
                            .frame(height: 4)
                        
                        Capsule()
                            .fill(Color("orange"))
                            .frame(width: vm.epoSlider, height: 4)
                        
                        // Slider....
                        
                        Circle()
                            .fill(Color("orange"))
                            .frame(width: 20, height: 20)
                        // gesture....
                            .offset(x: vm.epoSlider)
                            .gesture(DragGesture().onChanged(vm.updateVolume(value:)))
                    }
                    // default Frame...
//                    .frame(width: UIScreen.main.bounds.width - 160)
                    
//                    Slider(value: $vm.soundLevel, in: 0...1,step: 0.0625, onEditingChanged: { data in
                        
//                        MPVolumeView.setVolume(self.vm.soundLevel)
//                            })
//                    Slider(value:$slider)
                    
                    Image(systemName: "speaker.wave.2.fill")
                }
                .padding()
                
               
                .padding(.bottom,safeArea?.bottom == 0 ? 15 : safeArea?.bottom)
            }
            .frame( height:vm.expand ? nil : 0)
            .opacity(vm.expand ? 1 : 0)
        }
        //        .opacity(vm.selectedPodacst.artistName == nil ? 0 : 1)
        .frame(maxHeight: vm.expand ? .infinity : 80)
        
        //        .background(Color.red)
        .background(
            VStack(spacing:0) {
                BlurView()
                
                Divider()
            }
            //
            .onTapGesture(perform: {
                withAnimation(.spring()) {vm.expand=true}
            })
            //
        )
        .onAppear(perform: {
//            self.vm.fetchAlbum()
//            vm.playEpoisde()
        })
        .onReceive(timer) { (_) in
            if vm.haveChaned{
                vm.playEpoisde()
                return
//                timer.delay(for: .milliseconds(10), scheduler: .zero)
            }else {
            vm.updateTimer()
        }
        }
        .cornerRadius(vm.expand ? 20 : 0)
        .offset(y: vm.expand ? 0 : -48)
        .offset(y: offset)
        .gesture(DragGesture().onEnded(onended(value:)).onChanged(onChanged(value:)))
        .ignoresSafeArea()
        
    }
    
    func onended(value:DragGesture.Value)  {
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.95, blendDuration: 0.95 )){
            if value.translation.height > height {
                vm.expand=false
            }
            offset=0
        }
    }
    func onChanged(value:DragGesture.Value)  {
        //when only vm.show
        if value.translation.height > 0 && vm.expand {
            offset = value.translation.height
        }
    }
    
    func onEnded(value:DragGesture.Value)  {
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.95, blendDuration: 0.95 )){
            
            if value.translation.height > height {
                vm.expand = false
            }
            
            offset = 0
        }
    }
}

