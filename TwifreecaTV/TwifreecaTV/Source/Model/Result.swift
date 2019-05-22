//
//  Result.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 22/05/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Data?, Error)
}
