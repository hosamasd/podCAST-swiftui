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

extension NSNotification {
    static let downloadProgress = NSNotification.Name.init("downloadProgress")
    static let downloadComplete = NSNotification.Name.init("downloadComplete")
    
}

class APIServices:NSObject,URLSessionDownloadDelegate {
    
    typealias EposdeDownloadCompleteTuple = (title:String,filUrl:String)
    let baseUrlItunes = "https://itunes.apple.com/search"
    static let shared = APIServices()
    var eposide = EpoisdesModel(title: "", pubDate: Date(), description: "", author: "", streamUrl: "")
    var videoExtensions = ".m4a"
    
    
    func downloadEpoisde(epoisde: EpoisdesModel)  {
        eposide=epoisde
        let vv = epoisde.streamUrl
        videoExtensions = String(vv.suffix(4))
        let urlString = epoisde.streamUrl
        guard let url = URL(string: urlString) else { return  }
        
        
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
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

extension APIServices {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .downloadProgress, object: nil, userInfo: ["title":self.eposide.title,"progress":"\(Int(percentage * 100))%"])
            
        }
        
        print(percentage)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        do {
            let downloadedData = try Data(contentsOf: location)
            
            DispatchQueue.main.async(execute: {
                print("transfer completion OK!")
                let dd = UUID().uuidString
                let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
                let destinationPath = documentDirectoryPath.appendingPathComponent("\(dd)\(self.videoExtensions)")
                
                let pdfFileURL = URL(fileURLWithPath: destinationPath)
                FileManager.default.createFile(atPath: pdfFileURL.path,
                                               contents: downloadedData,
                                               attributes: nil)
                
                if FileManager.default.fileExists(atPath: pdfFileURL.path) {
                    print("pdfFileURL present!") // Confirm that the file is here!
                }
//                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .downloadComplete, object: nil, userInfo: ["title":self.eposide.title,"fileUrl":pdfFileURL])
//                }
            })
        } catch {
            print(error.localizedDescription)
        }
    }
}
