//
//  Storages.swift
//  podCAST
//
//  Created by hosam on 2/14/21.
//

import SwiftUI

//class KeyedUnarchiver : NSKeyedUnarchiver {
//    open override class func unarchiveObject(with data: Data) -> Any? {
//        do {
//            let object = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSObject.self], from: data)
//            return object
//        }
//        catch let error {
//            Swift.print("unarchiveObject(with:) \(error.localizedDescription)")
//            return nil
//        }
//    }
//
//    open override class func unarchiveObject(withFile path: String) -> Any? {
//        do {
//            let data = try Data(contentsOf: URL.init(fileURLWithPath: path))
//            let object = try unarchivedObject(ofClasses: [NSObject.self], from: data)
//            return object
//        }
//        catch let error {
//            Swift.print("unarchiveObject(withFile:) \(error.localizedDescription)")
//            return nil
//        }
//    }
//}

extension UserDefaults {
    static let ketTrack = "ketTrack"
    static let downloadEpoisdeKey = "downloadEpoisdeKey"
    func savePodcasts() -> [PodcastModel] {
        guard let keys = UserDefaults.standard.data(forKey: UserDefaults.ketTrack) else {return []}
        guard let podcasts = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(keys) as? [ PodcastModel] else {return []}

        return podcasts
    }
    
    func downloadEpoisde(epoisde: EpoisdesModel)  {
        var dowloadedEpoisdes = downloadedEpoisde()
        dowloadedEpoisdes.append(epoisde)
        do {
          let data =   try JSONEncoder().encode(dowloadedEpoisdes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadEpoisdeKey)
        } catch let err {
            print("failed to encode ",err.localizedDescription)
        }
      }
    
    func downloadedEpoisde() -> [EpoisdesModel] {
        guard let data = data(forKey: UserDefaults.downloadEpoisdeKey) else { return [] }
        
        do {
          let epoisde =   try JSONDecoder().decode([EpoisdesModel].self, from: data)
            return epoisde
        } catch let err {
            print("can not reterive data ",err.localizedDescription)
        }
        return []
    }
    
    func deletePodcast(pod: PodcastModel)  {
        let podcasts = savePodcasts()
        let filterPod = podcasts.filter { (p) -> Bool in
            return p.trackName != pod.trackName && p.artistName != pod.artistName
        }
        
        let data = NSKeyedArchiver.archivedData(withRootObject: filterPod)
        UserDefaults.standard.set(data, forKey: UserDefaults.ketTrack)
        
    }
    
    func deleteEpoisde(epoi: EpoisdesModel)  {
        let epoisdes = downloadedEpoisde()
        let filterEpoi = epoisdes.filter { (e) -> Bool in
            return e.title != e.title && e.author != e.author
        }
        
        let data = NSKeyedArchiver.archivedData(withRootObject: filterEpoi)
        UserDefaults.standard.set(data, forKey: UserDefaults.downloadEpoisdeKey)
        
    }
}
