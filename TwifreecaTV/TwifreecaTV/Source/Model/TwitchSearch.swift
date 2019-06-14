//
//  TwitchSearch.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 11/06/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import Foundation

struct TwitchSearch: Decodable {
    var data: [StreamerInfo]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct StreamerInfo: Decodable {
    var profileImageUrl: String
    var displayName: String
    var description: String
    var login: String
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case profileImageUrl = "profile_image_url"
        case displayName = "display_name"
        case login, id, description
    }
}
