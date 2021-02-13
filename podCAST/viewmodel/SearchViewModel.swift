//
//  SearchViewModel.swift
//  podCAST
//
//  Created by hosam on 2/13/21.
//

import SwiftUI

class SearchViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var txt = ""
    @Published     var poadcastArray = [PodcastModel]()
@Published var notFoundData = true
    
    
    func makeSearchOperation ()  {
        if txt != ""{
            
            searchPodcast()
        }
        else{
            
            // clearing all search results..
            
            txt = ""
            poadcastArray = []
            
        }
    }
    
    func searchPodcast()  {
        
        notFoundData=false
        isLoading=true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
            
            APIServices.shared.getPodcast(text: self.txt) { (pods, err) in
                
                if let err=err {
                    self.notFoundData=true
                    self.isLoading=false
                }
                
                guard let pods=pods else {return}
                
                DispatchQueue.main.async {
                    self.poadcastArray = pods.results
                    self.notFoundData=false
                    self.isLoading=true
                }
            }
        }
    }
    

}
