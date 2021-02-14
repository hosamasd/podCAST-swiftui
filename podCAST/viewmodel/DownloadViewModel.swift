//
//  DownloadViewModel.swift
//  podCAST
//
//  Created by hosam on 2/14/21.
//

import SwiftUI

class DownloadViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var isFavorite = false
    @Published      var eposdeArray = [EpoisdesModel]()
    @Published      var secondEposdeArray = [SecondEpoisdesModel]()
    
    @Published var notFoundData = false
    
    
    func getDownloads()  {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            let ss = UserDefaults.standard.downloadedEpoisde()
            ss.forEach { (p) in
                let d = SecondEpoisdesModel(title: p.title, pubDate: p.pubDate, description: p.description,imageUrl:p.imageUrl, author: p.author, streamUrl: p.streamUrl,fileUrl:p.fileUrl,offset:0)
                
                self.secondEposdeArray.append(d)
            }
            self.eposdeArray=ss
            
            self.notFoundData = self.eposdeArray.count <= 0 ? true : false
        }
    }
    
    func deleteEPoisde(p:SecondEpoisdesModel)  {
        let d = EpoisdesModel(title: p.title, pubDate: p.pubDate, description: p.description,imageUrl:p.imageUrl, author: p.author, streamUrl: p.streamUrl,fileUrl:p.fileUrl)
//        let s = EpoisdesModel(title: epo.title, pubDate: epo.pubDate, description: epo.description, author: epo.author, streamUrl: epo.streamUrl)
        self.secondEposdeArray.removeAll(where: {$0.id==p.id})
        self.eposdeArray.removeAll(where: {$0.id==p.id})

        UserDefaults.standard.deleteEpoisde(epoi: d)
        
    }
    
}
