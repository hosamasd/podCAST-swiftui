//
//  AlbumView.swift
//  Scroll tips
//
//  Created by hosam on 1/21/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct AlbumView : View {

    var album : EpoisdesModel
    
    var body: some View{
        
        HStack{
            
            WebImage(url: URL(string: album.imageUrl?.toSecrueHttps() ?? ""))
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(15)
            
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text(getDate())
                        .foregroundColor(.green)
                    
                    Text(album.title)
                        .fontWeight(.bold)
                    
                    Text(album.description)
                        .foregroundColor(.gray)
//                        .lineLimit(2)
                }
                .padding(.leading,10)
                
            
            
            Spacer(minLength: 0)
        }
        .background(Color.white.shadow(color: Color.black.opacity(0.12), radius: 5, x: 0, y: 4))
        .cornerRadius(15)
    }
    
    func getDate() ->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
       let dateString = dateFormatter.string(from: album.pubDate)
        return dateString
    }
}
