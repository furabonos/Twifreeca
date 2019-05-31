//
//  Method.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 21/05/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import UIKit

enum alertTypes {
    case RegisterError
    case RegisterSuccess
    case SearchError
}

class Method: NSObject {
    static func alert(type: alertTypes) -> UIAlertController {
        switch type {
        case .RegisterError:
            let alertController = UIAlertController(title: "알림",message: "이메일이 중복됩니다. \n 다시한번 확인해주세요", preferredStyle: UIAlertController.Style.alert)
            let cancelButton = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
            alertController.addAction(cancelButton)
            return alertController
        case .RegisterSuccess:
            let alertController = UIAlertController(title: "알림",message: "회원가입에 성공했습니다.", preferredStyle: UIAlertController.Style.alert)
            let cancelButton = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
            alertController.addAction(cancelButton)
            return alertController
        case .SearchError:
            let alertController = UIAlertController(title: "알림",message: "검색어를 한글자 이상 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
            let cancelButton = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
            alertController.addAction(cancelButton)
            return alertController
        default:
            break
        }
    }
}


