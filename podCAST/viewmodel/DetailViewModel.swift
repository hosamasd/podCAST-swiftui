//
//  DetailViewModel.swift
//  podCAST
//
//  Created by hosam on 2/13/21.
//

import SwiftUI

class DetailViewModel: ObservableObject {
    
    
    @Published var titleNabv = ""
    @Published var isLoading = false
    @Published var isFavorite = false
    @Published      var eposdeArray = [EpoisdesModel]()
    @Published var notFoundData = true
    
    func getAlls()  {
        // http://www.we-are-a.com/Site/A_Marbin/rss.xml
       
        notFoundData=false
        isLoading=true
        
        APIServices.shared.fetchEpoisdes(feedUrl:   "http://www.we-are-a.com/Site/A_Marbin/rss.xml".toSecrueHttps()) { (pods,err) in
            
            if let err=err {
                DispatchQueue.main.async {
                self.notFoundData=true
                self.isLoading=false
                }
            }
            
            guard let pods=pods else {return}
            DispatchQueue.main.async {
//                self.titleNabv = podcast.artistName ?? "No Name"
                self.eposdeArray = pods
                self.notFoundData=false
                self.isLoading=true
            }
        }
    }
    
    
    func getAll(podcast:PodcastModel)  {
        // http://www.we-are-a.com/Site/A_Marbin/rss.xml

        notFoundData=false
        isLoading=true

        APIServices.shared.fetchEpoisdes(feedUrl: podcast.feedUrl ?? "") { (pods,err) in

            if let err=err {
                DispatchQueue.main.async {
                self.notFoundData=true
                self.isLoading=false
                }
            }

            guard let pods=pods else {return}
            DispatchQueue.main.async {
                self.titleNabv = podcast.artistName ?? "No Name"
                self.eposdeArray = pods
                self.notFoundData = self.eposdeArray.count <= 0 ? true : false

                self.isLoading=true
            }
        }
    }
    
    // Simple Calculation for scaling Effect...
    
    func scaleValue(mainFrame : CGFloat,minY : CGFloat)-> CGFloat{
        
        // adding animation...
        
        withAnimation(.easeOut){
            
            // reducing top padding value...
            
            let scale = (minY - 25) / mainFrame
            
            // retuning scaling value to Album View if its less than 1...
            
            if scale > 1{
                
                return 1
            }
            else{
                
                return scale
            }
        }
    }
}
