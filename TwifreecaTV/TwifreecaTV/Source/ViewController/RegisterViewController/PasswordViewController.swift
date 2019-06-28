//
//  PasswordViewController.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 28/06/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import UIKit
import Firebase

class PasswordViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitEmail(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                print("error = \(error)")
                self.present(Method.alert(type: .FailPassword), animated: true)
            }else {
                print("sssssss")
                self.present(Method.alert(type: .SuccessPassword), animated: true, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
}
