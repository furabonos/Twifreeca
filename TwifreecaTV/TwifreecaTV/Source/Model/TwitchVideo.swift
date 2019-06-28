//
//  TwitchVideo.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 13/06/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import Foundation

struct TwitchVideo: Decodable {
    var data: [TwitchVideoInfo]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct TwitchVideoInfo: Decodable {
    var title: String
    var url: String
    var userName: String
    var thumbnailUrl: String
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case title, url, id
        case userName = "user_name"
        case thumbnailUrl = "thumbnail_url"
    }
}
