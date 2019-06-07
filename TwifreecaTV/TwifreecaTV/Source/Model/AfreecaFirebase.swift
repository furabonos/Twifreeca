//
//  AfreecaFirebase.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 07/06/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import Foundation

struct AfreecaFirebase: Decodable {
    var afreeca: [FavBJ]
    
    enum CodingKeys: String, CodingKey {
        case afreeca = "Afreeca"
    }
}

struct FavBJ: Decodable {
    var id: String
    var name: String
    var profileUrl: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case profileUrl = "profileurl"
    }
}
