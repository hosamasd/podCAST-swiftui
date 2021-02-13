//
//  PodcastDetail.swift
//  podCAST
//
//  Created by hosam on 2/13/21.
//

import SwiftUI

struct PodcastDetail: View {
    
    var podcast:PodcastModel
    
    @StateObject var vm = DetailViewModel()
    @State var show = false
    @State var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 1)
    var top = UIApplication.shared.windows.first?.safeAreaInsets.top
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            
        HStack(spacing: 15){
            
//      Spacer()
            
            Button(action: {
                withAnimation {presentationMode.wrappedValue.dismiss()}
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
                        print(123)
//                        show.toggle()
                    }
                    
                }) {
                    
                    Image(systemName: !vm.isFavorite ? "bookmark" : "bookmark.fill" )
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
//                        SearchView(columns: $columns, gradient: gradient, vm: vm)
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
        .navigationBarHidden(true)
        .navigationBarTitle("")
        .edgesIgnoringSafeArea(.all)
        
        .onAppear(perform: {
            self.vm.getAll(podcast: podcast)
        })
    }
}
