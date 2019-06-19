//
//  LoginViewController.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 20/05/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialize()
    }
    
    func setupInitialize() {
        passwordTextField.isSecureTextEntry = true
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -150 // Move view 150 points upward
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        
        guard let emails = emailTextField.text else { return }
        guard let passwords = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: emails, password: passwords) { (user, error) in
            if user != nil {
                //로그인 성공
                guard let uid = user?.user.uid else { return }
                UserSingleton.shared.uid = uid
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "TwitchViewController")
                self.navigationController?.pushViewController(newViewController, animated: true)
            }else {
                //실패
                print("로그인 실패")
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
