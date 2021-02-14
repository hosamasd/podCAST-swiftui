//
//  MainViewModel.swift
//  podCAST
//
//  Created by hosam on 2/13/21.
//

import SwiftUI

class MainViewModel: ObservableObject {
    
    @Published var offset:CGFloat = 0
    @Published var isMiniPlayer = false
    @Published var height:CGFloat = 0
    @Published var width:CGFloat = UIScreen.main.bounds.width
    @Published var show = false
    @Published var selectedPodacst = EpoisdesModel(title: "", pubDate: Date(), description: "", author: "", streamUrl: "")
    @Published var currentPodcast = PodcastModel()
    @Published var showToast=false
    @Published var isFavorite=false
    @Published var favoritePodcasts:[PodcastModel] = []
    @Published var secondfavoritePodcasts:[SecondPodcastModel] = []
    @Published var pinnedViews:[SecondPodcastModel] = []

    @Published var showText = false
    @Published var showTextDownload = false
    
    @Published var notFoundData=false
    
    func hasFavorite(pod:PodcastModel) -> Bool {
        let listOfPodcast = UserDefaults.standard.savePodcasts()
        return  listOfPodcast.contains(where: {pod.feedUrl==$0.feedUrl})
    }
    
    func removeFavorites(msg:SecondPodcastModel)  {
        let v = PodcastModel(artistName: msg.artistName, trackName: msg.trackName, artworkUrl600: msg.artworkUrl600, trackCount: msg.trackCount, feedUrl: msg.feedUrl)
//
        self.favoriteOrUnFavoritePodcast(pod:v )
        secondfavoritePodcasts.removeAll(where: {$0.feedUrl==v.feedUrl})
//        secondfavoritePodcasts.removeAll { (msg1) -> Bool in
//
//            if msg.feedUrl == msg1.feedUrl{return true}
//            else{return false}
//        }
    }
    
    func favoriteOrUnFavoritePodcast(pod:PodcastModel)  {
        var listOfPodcast = UserDefaults.standard.savePodcasts()
        
        if !hasFavorite(pod: pod) {
            listOfPodcast.append(pod)
            self.isFavorite = true
            do {
                let data =   try NSKeyedArchiver.archivedData(withRootObject: listOfPodcast, requiringSecureCoding: false)
                UserDefaults.standard.set(data, forKey: UserDefaults.ketTrack)
            } catch let err {
                print("error" + err.localizedDescription)
                //                createAlert(title: "Error", message: err.localizedDescription)
            }
        }else {
            UserDefaults.standard.deletePodcast(pod: pod)
            self.isFavorite = false
            
        }
        DispatchQueue.main.async {
            self.showToast.toggle()
            
        }
    }
    
    func getFavorites()  {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            let ss = UserDefaults.standard.savePodcasts()
            ss.forEach { (p) in
                let d = SecondPodcastModel(artistName: p.artistName, trackName: p.trackName, artworkUrl600: p.artworkUrl600, trackCount: p.trackCount, feedUrl: p.feedUrl,offset: 0)
                self.secondfavoritePodcasts.append(d)
            }
            self.favoritePodcasts=ss
            
            self.notFoundData=self.favoritePodcasts.count <= 0 ? true : false
        }
    }
    
    func download(eposide:EpoisdesModel)  {
        UserDefaults.standard.downloadEpoisde(epoisde: eposide)
        APIServices.shared.downloadEpoisde(epoisde: eposide)
    }
}
