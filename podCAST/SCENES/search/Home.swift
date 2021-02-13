//
//  Home.swift
//  podCAST
//
//  Created by hosam on 2/13/21.
//

import SwiftUI

struct Home: View {
    
    @StateObject var vm = SearchViewModel()
    @State var show = false
    @State var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 3)
    var top = UIApplication.shared.windows.first?.safeAreaInsets.top
    @State var isTwo = false

    var body: some View {
        
        VStack{
            
        HStack(spacing: 15){
            
            if show{
                
                TextField("Search Podcasts", text: $vm.txt)
                    // search Bar Functionality...
                    
                        .onChange(of: vm.txt) { (value) in
                            
                            vm.makeSearchOperation()
                        
                        }
                
             
                Button(action: {
                    
                    withAnimation(.easeOut){
                        
                        // clearing search...
                        vm.txt = ""
                        // safe side...
//                        vm.poadcastArray = []
                        show.toggle()
//                        vm.notFoundData=true
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
                        NavigationLink(destination: PodcastDetail(podcast:gradient)) {
                        SearchView(columns: $columns, gradient: gradient, vm: vm)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .zIndex(0)
            
            
        }
        
            Spacer()
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
