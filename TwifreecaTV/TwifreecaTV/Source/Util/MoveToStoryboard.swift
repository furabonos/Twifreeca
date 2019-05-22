//
//  MoveToStoryboard.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 21/05/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import UIKit

struct MoveStoryboard {
    static func toVC(storybardName: String, identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storybardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        return viewController
    }
}

