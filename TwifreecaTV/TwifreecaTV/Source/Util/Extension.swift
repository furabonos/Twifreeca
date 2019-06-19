//
//  Extension.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 27/05/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func replaces(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil) }
    
}

extension UINavigationController {
    
    func backToViewController(viewController: Swift.AnyClass) {
        
        for element in viewControllers as Array {
            if element.isKind(of: viewController) {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
}

