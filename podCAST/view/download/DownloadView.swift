//
//  DownloadView.swift
//  podCAST
//
//  Created by hosam on 2/14/21.
//

import SwiftUI
import SDWebImageSwiftUI
struct DownloadView: View {
    
    var msg:SecondEpoisdesModel
    @ObservedObject var vmm: DownloadViewModel
    
    var body: some View {
        
        ZStack  {
            //
            //                                // adding Buttons...
            //
            HStack{
                
                Spacer(minLength: 0)
                
                Color.red
                    .frame(width: 90)
                    .opacity(msg.offset < 0 ? 1 : 0)
                
            }
            //
            HStack{
                
                Spacer(minLength: 0)
                
                Button(action: {
                    
                    // removing from main View...
                    
                    withAnimation(.default){
                        self.vmm.deleteEPoisde(p: msg)
                        //                          self.vmm.removeFavorites(msg: msg)
                    }
                    
                }, label: {
                    
                    Image(systemName: "trash.fill")
                        .font(.title)
                        .foregroundColor(.white)
                })
                .frame(width: 90)
            }
            
            HStack(spacing: 15){
                
                ZStack(alignment: Alignment(horizontal: .center, vertical: .center), content: {
                    
               
                WebImage(url: URL(string: msg.imageUrl?.toSecrueHttps() ?? "")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80,height: 80)//, height: 60)
//                    .clipShape(Circle())
                    .cornerRadius(12)
                    
                    Text("\(msg.sssss)")
                        .font(.largeTitle)
                        .fontWeight(.regular)
                        .foregroundColor(.red)
                        
                
                })
                
                VStack(alignment: .leading,spacing: 10){
                    
                    Text(getDtaeString() )
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text(msg.title )
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .lineLimit(2)
                    
                    Text(msg.description )
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    
                    Divider()
                }
                
            }
            .padding(.all)
            .background(Color.white)
            .contentShape(Rectangle())
            // adding gesture...
            .offset(x: msg.offset)
            .gesture(DragGesture().onChanged({ (value) in
                //
                withAnimation(.default){
                    
                    vmm.secondEposdeArray[getIndex(profile: msg.id )].offset = value.translation.width > 0 ? 0 : value.translation.width
                }
                
            })
            .onEnded({ (value) in
                
                withAnimation(.default){
                    
                    
                    if value.translation.width < -80{
                        
                        vmm.secondEposdeArray[getIndex(profile: msg.id )].offset = -90
                    }
                    else{
                        
                        vmm.secondEposdeArray[getIndex(profile: msg.id )].offset = 0
                    }
                }
            }))
        }
        
    }
    
    func getDtaeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: msg.pubDate)
    }
    
    func getIndex(profile: String)->Int{
        
        var index = 0
        
        for i in 0..<vmm.secondEposdeArray.count{
            
            if profile == vmm.secondEposdeArray[i].id{
                
                index = i
            }
        }
        
        return index
    }
}

struct MaivView_Presviews: PreviewProvider {
    static var previews: some View {
        MaivView()
    }
}
