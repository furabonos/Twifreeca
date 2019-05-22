//
//  AfreecaSearch.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 22/05/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import Foundation

struct AfreecaSearch: Decodable {
    var bjlist: [BjListInfo]
    
    enum CodingKeys: String, CodingKey {
        case bjlist
    }
}

struct BjListInfo: Decodable {
    var bjname: String
    var broadcastName: String
    var bjid: String
    var broadcastMent: String
    var profileurl: String
    
    enum CodingKeys: String, CodingKey {
        case bjname
        case broadcastName
        case bjid
        case broadcastMent
        case profileurl
    }
}
