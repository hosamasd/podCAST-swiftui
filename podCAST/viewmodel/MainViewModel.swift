//
//  MainViewModel.swift
//  podCAST
//
//  Created by hosam on 2/13/21.
//

import SwiftUI
import AVKit
import UIKit
import MediaPlayer

class MainViewModel: ObservableObject {
    
    @Published var offset:CGFloat = 0
    @Published var isMiniPlayer = false
    @Published var height:CGFloat = 0
    @Published var width:CGFloat = UIScreen.main.bounds.width
    @Published var alert = false
    @Published var alertMsg = ""
    @Published var refreshDownload = false
    @Published var podcastAlert = EpoisdesModel(title: "", pubDate: Date(), description: "", author: "", streamUrl: "")
    @Published var show = false
    @Published var expand = false
    
    @Published var epoPlay = false
    @Published var epoSlider:CGFloat = 0
    @Published var epoOffset:CGFloat = 0.7
    @Published var epoValue:Float = 0
    @Published var epovTimeValue:CGFloat = 0
    //    @Published var epovTimeValue:CGFloat = 0
    @Published var epopCurrentTimeValue:String = "0:0"
    @Published var epopTotalTimeValue:String = "0:0"
    @Published var epopFloatTotalTimeValue:CGFloat = 0.0
    @Published var currentTimeAvAudio = ""
    @Published var totalTimeAvAudio = ""
    @Published var avPlayer: AVPlayer = {
        let av = AVPlayer()
        av.automaticallyWaitsToMinimizeStalling = false
        return av
    }()
    @Published var haveChaned = false
    @Published var doneChaned = false
    @Published var checkBookmarkChanged=false
    @Published var selectedPodacst = EpoisdesModel(title: "", pubDate: Date(), description: "", author: "", streamUrl: "") {
        didSet{
            playEpoisde()
            
        }
    }
    @Published var currentPodcast = PodcastModel()
    
    
    @Published var showToast=false
    @Published var isFavorite=false
    @Published var favoritePodcasts:[PodcastModel] = []
    @Published var secondfavoritePodcasts:[SecondPodcastModel] = []
    @Published var pinnedViews:[SecondPodcastModel] = []
    
    @Published var showText = false
    @Published var showTextDownload = false
    
    @Published var notFoundData=false
    
    
    //audio player
    @Published var angle : Double = 0
    
    @Published var volume : CGFloat = 0
    @Published var player :  AVAudioPlayer!
    
    @Published var isPlaying = false
    
    @Published var playListEpodsed = [EpoisdesModel]()
    
     func  handlePreviousEpoisde(){
        if playListEpodsed.count == 0  {
            return
        }
        
        let currenIndex = playListEpodsed.firstIndex {(ep) -> Bool in
            return self.selectedPodacst.title == ep.title &&
                self.selectedPodacst.author == ep.author
        }
        //
        guard let index = currenIndex else { return  }
        
        let previousEpoisde:EpoisdesModel
        if index == playListEpodsed.count - 1 {
            previousEpoisde = playListEpodsed[index]
        }else {
            previousEpoisde = playListEpodsed[0]
        }
        
        self.selectedPodacst = previousEpoisde
    }
    
     func  handleNextEpoisde(){
        if playListEpodsed.count == 0  {
            return
        }
        
        let currenIndex = playListEpodsed.firstIndex {(ep) -> Bool in
            return self.selectedPodacst.title == ep.title &&
                self.selectedPodacst.author == ep.author
        }
        
        guard let index = currenIndex else { return  }
        
        let previousEpoisde:EpoisdesModel
        if index == playListEpodsed.count - 1 {
            previousEpoisde = playListEpodsed[0]
        }else {
            previousEpoisde = playListEpodsed[index+1]
        }
        
        self.selectedPodacst = previousEpoisde
    }
    
    func playEpoisde()  {
        if selectedPodacst.fileUrl != nil {
            playEpoisdeUsingFileUrl()
        }else {
            getDefaultPlayer()
            
            
        }
        observeCurrentPlayerTime()
        //        haveChaned=false
    }
    
    func handlePlay(epo:EpoisdesModel)  {
        DispatchQueue.main.async {
            
            
            self.show = true
            self.selectedPodacst = epo
        }
    }
    
    func handleDownloadTap(epo:EpoisdesModel)  {
        if epo.fileUrl == nil {
            self.alert.toggle()
            self.alertMsg = "you don't download this item before do you want to watch it stream? "
            self.podcastAlert=epo
        }
        else {
            handlePlay(epo: epo)
        }
    }
    
    func handleDownloadComplete(userInfo: [String:Any]?){
        guard let userInfo = userInfo as? [String:Any] else { return  }
       guard let title = userInfo["title"] as? String else { return  }
       guard let fileUrl = userInfo["fileUrl"] as? URL else { return  }
       
        var downloadeEpoisde = UserDefaults.standard.downloadedEpoisde()
        if let index = downloadeEpoisde.firstIndex(where: {$0.title == title}) {
            
            downloadeEpoisde[index].fileUrl = fileUrl.absoluteString
            self.podcastAlert.fileUrl = fileUrl.absoluteString
            do{
                let data = try JSONEncoder().encode(downloadeEpoisde)
                UserDefaults.standard.set(data, forKey: UserDefaults.downloadEpoisdeKey)
                self.refreshDownload=true
            }catch let err {
                print("can not encode with file url ",err)
            }
        }
       
    }
    
    
    func getDefaultPlayer()  {
        guard let url = URL(string: selectedPodacst.streamUrl ) else { return }
        let playerItem = AVPlayerItem(url: url)
        
        avPlayer.replaceCurrentItem(with: playerItem)
        avPlayer.play()
        //            avPlayer.volume = Float(epoSlider)
        epoPlay=true
        enLargeImageView()
        
        
    }
    
    
    
    
    
    
    
    
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
            self.secondfavoritePodcasts.removeAll(where: {pod.feedUrl==$0.feedUrl})
            self.pinnedViews.removeAll(where: {pod.feedUrl==$0.feedUrl})
            self.checkBookmarkChanged=true
            
        }
        DispatchQueue.main.async {
            self.showToast.toggle()
            
        }
    }
    
    func getFavorites()  {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.favoritePodcasts.removeAll()
            self.secondfavoritePodcasts.removeAll()
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
    
    
    
    
    //        func playEpoisde()  {
    //            if selectedPodacst.fileUrl != nil {
    //                playEpoisdeUsingFileUrl()
    //            }else {
    //                guard let url = URL(string: selectedPodacst.streamUrl ) else { return }
    //                let playerItem = AVPlayerItem(url: url)
    //
    //                avPlayer.replaceCurrentItem(with: playerItem)
    //                avPlayer.play()
    //    //            avPlayer.volume = Float(epoSlider)
    //                epoPlay=true
    //                enLargeImageView()
    //            }
    //            observeCurrentPlayerTime()
    //    //        //        observeCurrentPlayerTime()
    //        }
    
    func playEpoisdeUsingFileUrl()  {
        guard let fileUrl   = URL(string: selectedPodacst.fileUrl ?? "" ) else {return}
        
        let fileName = fileUrl.lastPathComponent
        
        guard var trueLocation = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        
        trueLocation.appendPathComponent(fileName)
        
        let playerItem = AVPlayerItem(url: trueLocation)
        
        avPlayer.replaceCurrentItem(with: playerItem)
        avPlayer.play()
        //        avPlayer.volume = Float(epoSlider)
        epoPlay=true
        enLargeImageView()
    }
    
    func handlPlaying()  {
        if avPlayer.timeControlStatus == .paused  {
            avPlayer.play()
            
            epoPlay=true
            enLargeImageView()
        }else {
            avPlayer.pause()
            epoPlay=false
            shrinkImageView()
        }
    }
    
    fileprivate func enLargeImageView() {
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.epoOffset = 1
        }, completion: nil)
    }
    
    fileprivate func shrinkImageView() {
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.epoOffset = 0.7
        }, completion: nil)
    }
    
    //slider
    
    func updateCurrentSlider()  {
        let currentSec = CMTimeGetSeconds(avPlayer.currentTime())
        let total = CMTimeGetSeconds(avPlayer.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        
        self.epovTimeValue = CGFloat(currentSec / total)
    }
    
    func seekToCurrentTimes(delta: Int64) {
        //add fifteen seconds to slider
        let fifteenSecond = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(avPlayer.currentTime(), fifteenSecond)
        
        avPlayer.seek(to: seekTime)
        avPlayer.pause()
        epoPlay=false
        shrinkImageView()
    }
    
    func updateVolume(value: DragGesture.Value){
        
        // Updating Volume....
        
        // 160 width 20 circle size...
        // total 180
        
        if value.location.x >= 0 && value.location.x <= UIScreen.main.bounds.width - 180{
            
            // updating volume...
            let progress = value.location.x / UIScreen.main.bounds.width - 180
            player.volume = Float(progress)
            withAnimation(Animation.linear(duration: 0.1)){volume = value.location.x}
        }
    }
    
    func observeCurrentPlayerTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        avPlayer.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self ] (time) in
            
            self?.epopCurrentTimeValue = time.toStringDisplay()
            self?.epovTimeValue = CGFloat(time.seconds)
            guard  let duration =   self?.avPlayer.currentItem?.duration.toStringDisplay() else{return}
            self?.epopTotalTimeValue = duration
            self?.epopFloatTotalTimeValue =  CGFloat(Float(CMTimeGetSeconds((self?.avPlayer.currentTime())!)))
            
            //            self?.setupDurationInLockScreen()
            self?.updateCurrentSlider()
        }
    }
    
    
    
    func trackSliderTimer(_ value:DragGesture.Value)  {
        
        if value.location.x >= 0 && value.location.x <= UIScreen.main.bounds.width - 32{
            
            var ss = UIScreen.main.bounds.width - 32
            ////
            let ttt = value.location.x
            let p = ttt/ss
            
            let g = p*100
            let w = (g*epopFloatTotalTimeValue) / 100
            
            let sss = w*100
            
            
            let fifteenSecond = CMTimeMake(value: Int64(w), timescale: 1)
            let seekTime = CMTimeAdd(avPlayer.currentTime(), fifteenSecond)
            
            avPlayer.seek(to: seekTime)
            withAnimation(Animation.linear(duration: 0.1)){epovTimeValue = value.location.x}
        }
    }
    
    
    
    func checkAuthor() -> String {
        if selectedPodacst.author != "" {
            return selectedPodacst.author
        }else {
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: selectedPodacst.pubDate)
        }
    }
    
    //TODO: -//for playing in background and control auido in this place
    
    func setupRemoteControl()  {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let command = MPRemoteCommandCenter.shared()
        
        command.playCommand.isEnabled = true
        command.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.avPlayer.play()
//            self.playPauseButton.setImage(#imageLiteral(resourceName: "play-button-1"), for: .normal)
//            self.miniEpoisdePauseButton.setImage(#imageLiteral(resourceName: "play-button-1"), for: .normal)
            self.elipshedTime(playbackRate: 1)
           
            return .success
        }
        command.pauseCommand.isEnabled = true
        command.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.avPlayer.pause()
//            self.playPauseButton.setImage(#imageLiteral(resourceName: "pause-button"), for: .normal)
//            self.miniEpoisdePauseButton.setImage(#imageLiteral(resourceName: "pause-button"), for: .normal)
            
            self.elipshedTime(playbackRate: 0)
            return .success
        }
        
        command.togglePlayPauseCommand.isEnabled = true
        command.togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.handlPlaying()
            return .success
        }
        command.nextTrackCommand.addTarget(self, action: #selector(handleNextEpoisdes))
        command.previousTrackCommand.addTarget(self, action: #selector(handlePreviousEpoisdes))
    }
    
    func elipshedTime(playbackRate: Float)  {
        let elipshedTime = CMTimeGetSeconds(avPlayer.currentTime())
        
         MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = elipshedTime
         MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = playbackRate
    }
    
    @objc func handleNextEpoisdes(){

        if playListEpodsed.count == 0 {
            return
        }
        let currenIndex = playListEpodsed.index {(ep) -> Bool in
            return self.epoisde.title == ep.title &&
            self.epoisde.author == ep.author
        }

        guard let index = currenIndex else { return  }

        let nextEpoisde:EpoisdesModel
        if index == playListEpodsed.count - 1 {
            nextEpoisde = playListEpodsed[0]
        }else {
            nextEpoisde = playListEpodsed[index + 1]
        }

        self.selectedPodacst = nextEpoisde
    }
    
    @objc func  handlePreviousEpoisdes(){
        if playListEpodsed.count == 0  {
            return
        }
        
        let currenIndex = playListEpodsed.firstIndex {(ep) -> Bool in
            return self.selectedPodacst.title == ep.title &&
                self.selectedPodacst.author == ep.author
        }
        //
        guard let index = currenIndex else { return  }
        
        let previousEpoisde:EpoisdesModel
        if index == playListEpodsed.count - 1 {
            previousEpoisde = playListEpodsed[index]
        }else {
            previousEpoisde = playListEpodsed[0]
        }
        
        self.selectedPodacst = previousEpoisde
    }
}


//avaudio player
//func getDefaultPlayer()  {
//
//    let ss = selectedPodacst.streamUrl.hasSuffix(".mp3")
//
//    guard let url = URL(string: selectedPodacst.streamUrl.toSecrueHttps() ) else { return }
//
//
//    do {
//        if ss {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
//                       try AVAudioSession.sharedInstance().setActive(true)
//            let soundData = try Data(contentsOf:url)
//            player = try  AVAudioPlayer(data: soundData)
//            player.volume = 1
////                player = try   AVAudioPlayer(contentsOf: url)
//            volume = CGFloat(player.volume) * (UIScreen.main.bounds.width - 180)
//            updateTimer()
//        }else {
//
//
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
//                       try AVAudioSession.sharedInstance().setActive(true)
//
//            let soundData = try Data(contentsOf:url)
//            player = try  AVAudioPlayer(data: soundData)
//            player.volume = 1
//            volume = CGFloat(player.volume) * (UIScreen.main.bounds.width - 180)
//            updateTimer()
//        }
//
//    } catch let err {
//        print (err.localizedDescription)
//    }
//}
//
//func handlePlay(epo:EpoisdesModel)  {
//    DispatchQueue.main.async {
//
//
//        self.show = true
//        self.selectedPodacst = epo
//    }
//}
//
//func fetchAlbum(){
//
//    if player==nil {
//        getDefaultPlayer()
//    }
//
//
//
//    if player.url == nil {
//        guard let url = URL(string: selectedPodacst.streamUrl ) else { return }
//
//        do {
//            let soundData = try Data(contentsOf:url)
//            player = try AVAudioPlayer(data: soundData)
//
//            totalTimeAvAudio = getCurrentTime(value: player.duration)
//            currentTimeAvAudio = getCurrentTime(value: player.currentTime)
//            // fetching audio volume level...
//
//            volume = CGFloat(player.volume) * (UIScreen.main.bounds.width - 180)
//        } catch let err {
//            print (err.localizedDescription)
//        }
//    }
//}
//
//func updateTimer(){
//
//    let currentTime = player.currentTime
//    let total = player.duration
//    let progress = currentTime / total
//
//    withAnimation(Animation.linear(duration: 0.1)){
//
//        self.angle = Double(progress) * 288
//    }
//    isPlaying = player.isPlaying
//    totalTimeAvAudio = getCurrentTime(value: player.duration)
//    currentTimeAvAudio = getCurrentTime(value: player.currentTime)
//
//    //        enLargeImageView()
//}
//
//func onChanged(value: DragGesture.Value){
//
//    let vector = CGVector(dx: value.location.x, dy: value.location.y)
//
//    // 12.5 = 25 => Circle Radius...
//
//    let radians = atan2(vector.dy - 12.5, vector.dx - 12.5)
//    let tempAngle = radians * 180 / .pi
//
//    let angle = tempAngle < 0 ? 360 + tempAngle : tempAngle
//
//    // since maximum slide is 0.8
//    // 0.8*36 = 288
//    if angle <= 288{
//
//        // getting time...
//        let progress = angle / 288
//
//        let time = TimeInterval(progress) * player.duration
//
//
//        player.currentTime = time
//        player.play()
//        withAnimation(Animation.linear(duration: 0.1)){self.angle = Double(angle)}
//    }
//}
//
//func play(){
//
//    if player.isPlaying{player.pause()
//        shrinkImageView()
//    }
//    else{player.play()
//        enLargeImageView()
//    }
//    isPlaying = player.isPlaying
//
//}
//
//func getCurrentTime(value: TimeInterval)->String{
//
//    return "\(Int(value / 60)):\(Int(value.truncatingRemainder(dividingBy: 60)) < 9 ? "0" : "")\(Int(value.truncatingRemainder(dividingBy: 60)))"
//}
//
//func updateVolumes(value: DragGesture.Value){
//
//    // Updating Volume....
//
//    // 160 width 20 circle size...
//    // total 180
//
//    if value.location.x >= 0 && value.location.x <= UIScreen.main.bounds.width - 180{
//
//        // updating volume...
//        let progress = value.location.x / UIScreen.main.bounds.width - 180
//        player.volume = Float(progress)
//        withAnimation(Animation.linear(duration: 0.1)){volume = value.location.x}
//    }
//}
