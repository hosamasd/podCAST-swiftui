//
//  EpoisdesModel.swift
//  Poadcast
//
//  Created by hosam on 5/1/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import FeedKit

struct EpoisdesModel: Codable,Identifiable {
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

