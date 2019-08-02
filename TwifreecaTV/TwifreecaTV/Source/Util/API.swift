//
//  API.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 22/05/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import Foundation

struct API {
    
    static let searchURL = "http://13.209.97.201:5000/bjlist"
    static let liveURL = "http://13.209.97.201:5000/livenow"
    
    static let twitchURL = "https://api.twitch.tv/helix"
    
    struct Afreeca {
        
    }
    
    struct Twitch {
        static let twitchSearchURL = "\(twitchURL)/users"
        static let twitchVideoURL = "\(twitchURL)/videos"
        static let twitchLiveURL = "\(twitchURL)/streams"
    }
}
