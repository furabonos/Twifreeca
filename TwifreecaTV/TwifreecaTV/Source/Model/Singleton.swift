//
//  Singleton.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 21/05/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import Foundation

class UserSingleton {
    static let shared = UserSingleton()
    private init() {}
    var uid = ""
}
