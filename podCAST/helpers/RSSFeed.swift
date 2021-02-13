//
//  RSSFeed.swift
//  podCAST
//
//  Created by hosam on 2/13/21.
//
import FeedKit

extension RSSFeed {
    
    func toEpoisdes() -> [EpoisdesModel] {
        let imageUrl = iTunes?.iTunesImage?.attributes?.href
        
        var epoisdes = [EpoisdesModel]()
        items?.forEach({ (feedItem) in
            
            var epoisde = EpoisdesModel(feed: feedItem)
            if epoisde.imageUrl == nil {
                epoisde.imageUrl = imageUrl
            }
            epoisdes.append(epoisde)
        })
        return epoisdes
    }
}
