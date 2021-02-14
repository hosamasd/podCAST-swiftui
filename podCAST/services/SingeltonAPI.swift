//
//  SingeltonAPI.swift
//  Poadcast
//
//  Created by hosam on 4/30/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
//import Alamofire
import FeedKit

extension Notification.Name {
    static let downloadProgress = Notification.Name("downloadProgress")
    static let downloadComplete = Notification.Name("downloadComplete")
}

class APIServices {
    
    typealias EposdeDownloadCompleteTuple = (title:String,filUrl:String)
    let baseUrlItunes = "https://itunes.apple.com/search"
    static let shared = APIServices()
    
    func downloadEpoisde(epoisde: EpoisdesModel)  {
//        let downloadRequest = DownloadRequest.suggestedDownloadDestination()
//
//        Alamofire.download(epoisde.streamUrl, to: downloadRequest).downloadProgress { (progress) in
//
//            //post notification here to called with downloadvc
//            NotificationCenter.default.post(name: .downloadProgress, object: nil, userInfo: ["title":epoisde.title,"progress":progress.fractionCompleted])
//            }.response { (res) in
//                guard let fileUrl =  res.destinationURL?.absoluteString else {return}
//                let epoisdeDownloadComplete = EposdeDownloadCompleteTuple(fileUrl,epoisde.title)
//
//                NotificationCenter.default.post(name: .downloadComplete, object: epoisdeDownloadComplete, userInfo: nil)
//
//                var downloadeEpoisde = UserDefaults.standard.downloadedEpoisde()
//                guard let index = downloadeEpoisde.index(where: {
//                    $0.author == epoisde.author &&
//                        $0.title == epoisde.title
//                }) else {return}
//
//                downloadeEpoisde[index].fileUrl = fileUrl
//                do{
//                    let data = try JSONEncoder().encode(downloadeEpoisde)
//                    UserDefaults.standard.set(data, forKey: UserDefaults.downloadEpoisdeKey)
//
//                }catch let err {
//                    print("can not encode with file url ",err)
//                }
//        }
    }
    
    func fetchEpoisdes(feedUrl:String,completion:  @escaping ([EpoisdesModel]?,Error?)->())  {
        
         guard let feedUrl =  URL(string: feedUrl) else { return  }
        //put it in background thread
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: feedUrl)
            parser.parseAsync { (result) in

                switch result {
                case   .failure(let err):
                print("an error happened ",err.localizedDescription)
                completion(nil,err)
                   
                case .success(let feeds):
                   
                    
                    guard let feed = feeds.rssFeed else {return}
                    let epoisdes = feed.toEpoisdes()
                    completion(epoisdes,nil)
                }
            }
        }
    }
    
    func getPodcast(text:String,completion: @escaping (Result?,Error?)->())   {
        
         let urlString = baseUrlItunes + "?term=" + text + "&media=podcast"
    
        let originalString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlString
        
        APIServices.registerationGetMethodGenerics(urlString: originalString, completion: completion)
        
//        Alamofire.request(baseUrlItunes, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (response) in
//            if let err = response.error {
//                print(err)
//                return
//            }
//            guard let data = response.data else {return}
//            do{
//                let welcome = try JSONDecoder().decode(Result.self, from: data)
//                
//                welcome.results.forEach({ (pod) in
//                    completion(pod)
//                })
//                
//                
//            }catch let err {
//                print(err.localizedDescription)
//            }
//        }
    }
    
    static func registerationPostMethodGeneric<T:Codable>(postString:String,url:URL,completion:@escaping (T?,Error?)->Void)  {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            if let error = err {
                completion(nil,error)
            }
            guard let data = data else {return}
            do {
                let objects = try JSONDecoder().decode(T.self, from: data)
                // success
                completion(objects,nil)
            } catch let error {
                completion(nil,error)
            }
        }.resume()
    }
    
    static func registerationGetMethodGenerics<T:Codable>(urlString:String,completion:@escaping (T?,Error?)->Void)  {
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                completion(nil, err)
                return
            }
            do {
                let objects = try JSONDecoder().decode(T.self, from: data!)
                // success
                completion(objects, err)
            } catch let error {
                completion(nil, error)
            }
        }.resume()
    }
    
}
