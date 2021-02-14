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
    
    func hasFavorite(pod:PodcastModel) -> Bool {
        let listOfPodcast = UserDefaults.standard.savePodcasts()
        return  listOfPodcast.contains(where: {pod.feedUrl==$0.feedUrl})
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
}
