//
//  Home.swift
//  podCAST
//
//  Created by hosam on 2/13/21.
//

import SwiftUI

var top = UIApplication.shared.windows.first?.safeAreaInsets.top

struct Home: View {
    
    @StateObject var vm = SearchViewModel()
    @State var show = false
    @State var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 3)
    @State var isTwo = false
    //    @EnvironmentObject var chain: ResponderChain
    @State private var becomeFirstResponder = false
    @State var showDetail=false
    @State var gradient = PodcastModel()
    
    var body: some View {
        
        ZStack {
            
            VStack{
                
                HStack(spacing: 15){
                    
                    if show{
                        
                        //                CustomTextField(becomeFirstResponder: $becomeFirstResponder,text: $vm.txt)
                        TextField("Search Podcasts", text: $vm.txt)
                            // search Bar Functionality...
                            
                            .onChange(of: vm.txt) { (value) in
                                
                                vm.makeSearchOperation()
                                
                            }
                        
                        
                        Button(action: {
                            
                            withAnimation(.easeOut){
                                
                                // clearing search...
                                vm.txt = ""
                                show.toggle()
                            }
                            
                        }) {
                            
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                        }
                        
                        
                    }
                    else{
                        
                        Text("Search")
                            .font(.system(size: 30))
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: {
                            
                            withAnimation(.easeOut){
                                self.becomeFirstResponder.toggle()
                                show.toggle()
                            }
                            
                        }) {
                            
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                        }
                        
                        Button(action: {
                            
                            withAnimation(.easeOut){
                                
                                if columns.count == 1{
                                    
                                    columns.append(GridItem(.flexible(), spacing: 20))
                                    isTwo = true
                                }
                                else if columns.count == 2 {
                                    if isTwo {
                                        columns.append(GridItem(.flexible(), spacing: 20))
                                    }else {
                                        columns.removeLast()
                                    }
                                    isTwo = false
                                }
                                else{
                                    
                                    columns.removeLast()
                                }
                            }
                            
                        }) {
                            
                            Image(systemName: columns.count == 1 ? "square.grid.2x2.fill" : "rectangle.grid.1x2.fill")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                        }
                    }
                    
                    
                }
                .padding(.top,top)
                .padding(.bottom,10)
                .padding(.horizontal)
                
                .zIndex(1)
                
                // Vstack Bug..
                
                if vm.notFoundData {
                    Text("No search artist done before!")
                        .fontWeight(.semibold)
                        .font(.system(size: 18))
                        .padding(.top,55)
                    
                    Spacer()
                } else
                
                if vm.poadcastArray.isEmpty{
                    
                    // loading View...
                    ProgressView()
                        .padding(.top,55)
                    
                    Spacer()
                }
                
                else {
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        
                        LazyVGrid(columns: columns,spacing: 20){
                            
                            // assigning name as ID...
                            
                            ForEach(vm.poadcastArray,id: \.feedUrl){gradient in
                                
                                //                        NavigationLink(destination: PodcastDetail(podcast:gradient)) {
                                SearchView(columns: $columns, gradient: gradient, vm: vm)
                                    .onTapGesture(perform: {
                                        withAnimation{
                                            self.gradient=gradient
                                            self.showDetail.toggle()
                                        }
                                    })
                                //                        }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    .zIndex(0)
                    
                    
                }
                
                Spacer()
            }
            .opacity(showDetail ? 0 : 1)
            if showDetail {
                PodcastDetail(podcast:gradient,showsss: $showDetail)
                    .transition(.move(edge: .bottom))
//                    .opacity(!showDetail ? 0 : 1)
            }
            
        }
        .navigationBarHidden(true)
        .navigationBarTitle("")
        .edgesIgnoringSafeArea(.all)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
