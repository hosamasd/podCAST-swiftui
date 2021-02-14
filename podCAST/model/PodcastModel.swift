//
//  PodcastModel.swift
//  Poadcast
//
//  Created by hosam on 4/30/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class PodcastModel:NSObject, Codable , NSCoding{
    internal init(artistName: String? = nil, trackName: String? = nil, artworkUrl600: String? = nil, trackCount: Int? = nil, feedUrl: String? = nil) {
        self.artistName = artistName
        self.trackName = trackName
        self.artworkUrl600 = artworkUrl600
        self.trackCount = trackCount
        self.feedUrl = feedUrl
    }
    
    
    func encode(with aCoder: NSCoder) {
        print("podcast to data")
        aCoder.encode(trackName ?? "",forKey: "trackName")
        aCoder.encode(artistName ?? "",forKey: "artistName")
        aCoder.encode(artworkUrl600 ?? "",forKey: "artworkUrl600")
        aCoder.encode(feedUrl ?? "",forKey: "feedUrl")
    }
    
    required init?(coder aDecoder: NSCoder) {
        print("data to podcast")
        self.trackName = aDecoder.decodeObject(forKey: "trackName") as? String
        self.artistName = aDecoder.decodeObject(forKey: "artistName") as? String
        self.artworkUrl600 = aDecoder.decodeObject(forKey: "artworkUrl600") as? String
        self.feedUrl = aDecoder.decodeObject(forKey: "feedUrl") as? String
        
    }
    
    
    
    
    var artistName:String?
    var trackName:String?
    var artworkUrl600:String?
    var trackCount:Int?
    var feedUrl:String?
    
}

struct Result: Codable {
    let resultCount: Int
    let results:[PodcastModel] 
    
    
    
}
