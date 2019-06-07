//
//  AfreecaLive.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 07/06/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import Foundation

struct AfreecaLiveInfo: Decodable {
    var streamImg: String
    var streamNow: String
    var streamTitle: String
    
    enum CodingKeys: String, CodingKey {
        case streamImg = "streamimg"
        case streamNow = "streamnow"
        case streamTitle = "streamtitle"
    }
}
