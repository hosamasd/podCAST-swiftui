//
//  EpoisdesModel.swift
//  Poadcast
//
//  Created by hosam on 5/1/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import FeedKit

struct SecondEpoisdesModel:Identifiable{
    
    var id = UUID().uuidString
    
    var title:String
    let pubDate:Date
    let description:String
    var imageUrl:String?
    let author :String
    let streamUrl:String
    var fileUrl:String?
    var offset:CGFloat = 0
    var sssss = ""
    
    
}

struct EpoisdesModel: Codable,Identifiable {
    internal init(id: String = UUID().uuidString, title: String, pubDate: Date, description: String, imageUrl: String? = nil, author: String, streamUrl: String, fileUrl: String? = nil) {
        self.id = id
        self.title = title
        self.pubDate = pubDate
        self.description = description
        self.imageUrl = imageUrl
        self.author = author
        self.streamUrl = streamUrl
        self.fileUrl = fileUrl
    }
    
    var id = UUID().uuidString
    
    let title:String
    let pubDate:Date
    let description:String
    var imageUrl:String?
    let author :String
    let streamUrl:String
    var fileUrl:String? 
    
    
    init(feed:RSSFeedItem) {
        self.streamUrl = feed.enclosure?.attributes?.url ?? ""
        self.title = feed.title ?? ""
        self.pubDate = feed.pubDate ?? Date()
        self.description = feed.iTunes?.iTunesSubtitle ?? feed.description ?? ""
        self.imageUrl = feed.iTunes?.iTunesImage?.attributes?.href
        self.author = feed.author ?? ""
        self.id  = UUID().uuidString
        
    }
}

