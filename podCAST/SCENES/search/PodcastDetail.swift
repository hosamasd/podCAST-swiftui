//
//  PodcastDetail.swift
//  podCAST
//
//  Created by hosam on 2/13/21.
//

import SwiftUI

struct PodcastDetail: View {
    
    var podcast:PodcastModel
    @Binding var showsss:Bool
    @StateObject var vm = DetailViewModel()
    @State var show = false
    @State var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 1)
    var top = UIApplication.shared.windows.first?.safeAreaInsets.top
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vmm: MainViewModel
    //    @StateObject var vmm = MainViewModel()
    @GestureState var gestureOffset:CGFloat = 0 //avoid glitches
    @Namespace var animation
    
    var body: some View {
        ZStack(alignment: .bottom, content: {
            
            VStack{
                
                HStack(spacing: 15){
                    
                    //      Spacer()
                    
                    Button(action: {
                        withAnimation {
//                            presentationMode.wrappedValue.dismiss()
                            self.showsss.toggle()
                        }
                    }, label: {
                        
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .foregroundColor(.black)
                            .frame(width:20,height: 20)
                    })
                    
                    Spacer()
                    
                    Text(vm.titleNabv)
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                    
                    
                    Spacer()
                    
                    Button(action: {
                        
                        withAnimation(.easeOut){
                            vmm.favoriteOrUnFavoritePodcast(pod: podcast)
                            print(123)
                            //                        show.toggle()
                        }
                        
                    }) {
                        
                        Image(systemName: !vmm.hasFavorite(pod: podcast) ? "bookmark" : "bookmark.fill" )
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                    }
                    
                }
                
                
                
                .padding(.top,top)
                .padding(.bottom,10)
                .padding(.horizontal)
                
                .zIndex(0)
                
                // Vstack Bug..
                
                if vm.notFoundData {
                    Text("No data found!!")
                        .fontWeight(.semibold)
                        .font(.system(size: 18))
                        .padding(.top,55)
                    
                    Spacer()
                } else
                
                if vm.eposdeArray.isEmpty{
                    
                    // loading View...
                    ProgressView()
                        .padding(.top,55)
                    
                    Spacer()
                }
                
                else {
                    
                    // Scaling Effect....
                    
                    GeometryReader{mainView in
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            
                            
                            LazyVGrid(columns: columns,spacing: 20){
                                
                                
                                // assigning name as ID...
                                
                                ForEach(vm.eposdeArray){gradient in
                                    
                                    GeometryReader{item in
                                        
                                        AlbumView(album: gradient)
                                            .scaleEffect(vm.scaleValue(mainFrame: mainView.frame(in: .global).minY, minY: item.frame(in: .global).minY),anchor:  .bottom)
                                            // adding opacity effect...
                                            .opacity(Double(vm.scaleValue(mainFrame: mainView.frame(in: .global).minY, minY: item.frame(in: .global).minY)))
                                            .contextMenu(menuItems: {
                                                VStack {
                                                    Button(action: {
                                                        withAnimation{
                                                            self.vmm.handlePlay(epo: gradient)
                                                        }
                                                    }, label: {
                                                        Text("Play")
                                                            .foregroundColor(.green)
                                                    })
                                                    
                                                    Button(action: {
//                                                        self.vmm.selectedPodacst = gradient
//                                                        self.vmm.show.toggle()
//                                                        self.vmm.showTextDownload = true
                                                        self.vmm.download(eposide: gradient)
                                                        
                                                    }, label: {
                                                        Text("Download")
                                                            .foregroundColor(.red)
                                                    })
                                                    
                                                    
                                                }
                                            })
                                            .contentShape(RoundedRectangle(cornerRadius: 5))
                                    }
                                }
                                // setting default frame height...
                                // since each card height is 100...
                                .frame(height: 180)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top,25)
                    }
                    .zIndex(1)
                    
                    
                }
                
                Spacer()
            }
        })
        .onChange(of: gestureOffset, perform: { value in
            onChanged()
        })
        .environmentObject(vm)
        
//        .navigationBarHidden(true)
//        .navigationBarTitle("")
        .edgesIgnoringSafeArea(.all)
        
        .onAppear(perform: {
            self.vm.getAll(podcast: podcast)
        })
        .environmentObject(vmm)
        
    }
    
    func onChanged()  {
        if gestureOffset > 0 && !vmm.isMiniPlayer && vmm.offset+70<=vmm.height {
            
            vmm.offset=gestureOffset
        }
    }
    
    func onEnded(vale:DragGesture.Value)  {
        withAnimation(.default){
            
            
            if !vmm.isMiniPlayer {
                vmm.offset=0
                if vale.translation.height > UIScreen.main.bounds.height / 3 {
                    vmm.isMiniPlayer = true
                }else {
                    vmm.isMiniPlayer = false
                }
            }
        }
    }
}


struct ContentView_Prevsiews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
