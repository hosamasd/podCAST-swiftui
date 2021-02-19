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
    @Published var progressDownload:String = ""
    @Published var notFoundData = false
    
    
    func getDownloads()  {
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.eposdeArray.removeAll()
            self.secondEposdeArray.removeAll()
            let ss = UserDefaults.standard.downloadedEpoisde()
            ss.forEach { (p) in
                let d = SecondEpoisdesModel(title: p.title, pubDate: p.pubDate, description: p.description,imageUrl:p.imageUrl, author: p.author, streamUrl: p.streamUrl,fileUrl:p.fileUrl,offset:0)
                
                self.secondEposdeArray.append(d)
            }
            self.eposdeArray=ss
            
            self.notFoundData = self.eposdeArray.count <= 0 ? true : false
//        }
    }
    
    func deleteEPoisde(p:SecondEpoisdesModel)  {
        let d = EpoisdesModel(title: p.title, pubDate: p.pubDate, description: p.description,imageUrl:p.imageUrl, author: p.author, streamUrl: p.streamUrl,fileUrl:p.fileUrl)
//        let s = EpoisdesModel(title: epo.title, pubDate: epo.pubDate, description: epo.description, author: epo.author, streamUrl: epo.streamUrl)
        self.secondEposdeArray.removeAll(where: {$0.id==p.id})
        self.eposdeArray.removeAll(where: {$0.id==p.id})

        UserDefaults.standard.deleteEpoisde(epoi: d)
        
    }
    
     func handleDownloadComplete(notify: Notification){
    guard let object = notify.object as? APIServices.EposdeDownloadCompleteTuple else { return  }
        
        guard let index = self.eposdeArray.firstIndex(where: {$0.title == object.title}) else { return  }
//        guard let index = self.eposdeArray.index(where: {
//            $0.title == object.title
//        })else {return}
        self.eposdeArray[index].fileUrl = object.filUrl
        self.secondEposdeArray[index].fileUrl = object.filUrl
    }
    
     func handleDownloadProgress(userInfo: [String:Any]?){
        guard let userInfo = userInfo else { return  }
        guard let title = userInfo["title"] as? String else { return  }
        guard let progress = userInfo["progress"] as? String else { return  }
        
//        guard let index = self.eposdeArray.firstIndex(where: {$0.title == title}) else { return  }
//         let epo = self.eposdeArray.filter({$0.title==title})
//        guard let ss = epo.first else {return}
       

        DispatchQueue.main.async {
            if let index = self.secondEposdeArray.firstIndex(where: {$0.title == title}) {
                self.secondEposdeArray[index].sssss = self.getPercentage(progress)
//                  self.getPercentage(progress, completion: { (v) in
//                    self.secondEposdeArray[index].sssss = v
//                })//progress
            }
        }
        
     }
    
//    func handleDownloadComplete(userInfo: [String:Any]?){
//        guard let userInfo = userInfo as? [String:Any] else { return  }
//       guard let title = userInfo["title"] as? String else { return  }
//       guard let fileUrl = userInfo["fileUrl"] as? URL else { return  }
//       
//        var downloadeEpoisde = UserDefaults.standard.downloadedEpoisde()
//        if let index = downloadeEpoisde.firstIndex(where: {$0.title == title}) {
//            
//            downloadeEpoisde[index].fileUrl = fileUrl.absoluteString
//           
//            do{
//                let data = try JSONEncoder().encode(downloadeEpoisde)
//                UserDefaults.standard.set(data, forKey: UserDefaults.downloadEpoisdeKey)
//                
//            }catch let err {
//                print("can not encode with file url ",err)
//            }
//        }
//       
//    }
    
//    func getPercentage(_ v:String,  completion: @escaping ((String)->()))  {
//        var xx = v
//
//        if v == "100%" {
//
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
//                xx =  ""
//                completion(xx)
//            }
//        }else {
//            completion(xx)
//        }
//    }
    
    func getPercentage(_ v:String)->String  {
        var xx = v
        
        if v == "100%" {
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
//                xx =  ""
//            }
            xx=""
    return xx
        }else {
    return xx
        }
    }
}
