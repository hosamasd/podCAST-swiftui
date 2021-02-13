//
//  SearchView.swift
//  podCAST
//
//  Created by hosam on 2/13/21.
//

import SwiftUI

struct SearchView: View {
    
    @Binding var columns:[GridItem]
    var gradient:PodcastModel
    var vm:SearchViewModel
    
    
    var body: some View {
            
        if columns.count == 2 || columns.count == 3 {
                
            ZStack{
                
                Image(systemName: "person")
                    .resizable()
//                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                    .clipShape(CShape(corners: [.topRight,.bottomLeft]))
                    .cornerRadius(15)
                
                
                Text((gradient.artistName ?? gradient.trackName) ?? "Not Avaiable!")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal)
            }
                
        }
        
            if columns.count == 1 {

                HStack(spacing: 15){

                    Image(systemName: "person")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80)
                    
                    VStack {

                    Text(gradient.artistName ?? "Not Avaiable!")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        Text(gradient.artistName ?? ""  )
                            .fontWeight(.semibold)
                                .foregroundColor(.gray)
                        
                        Text("\(gradient.trackCount ?? 0) epoiseds" )
                            .fontWeight(.regular)
                                .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
            }
    }
}
