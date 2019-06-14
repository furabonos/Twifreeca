//
//  TwitchLive.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 11/06/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import Foundation

struct TwitchLive: Decodable {
    var data: [StreamerLiveInfo]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct StreamerLiveInfo: Decodable {
    var title: String
    var thumbnailUrl: String
    var viewerCount: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case thumbnailUrl = "thumbnail_url"
        case viewerCount = "viewer_count"
    }
}
