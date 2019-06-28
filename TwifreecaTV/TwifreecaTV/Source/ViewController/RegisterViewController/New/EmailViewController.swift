//
//  EmailViewController.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 20/05/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import UIKit
import FirebaseAuth

class EmailViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialize()
        
    }
    
    func setupInitialize() {
        emailErrorLabel.text = ""
        passwordErrorLabel.text = ""
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func finishBtn(_ sender: Any) {
        guard let emails = emailTextField.text else { return }
        guard let passwords = passwordTextField.text else { return }
        
        if emails.emailRegex() == true, passwords.passwordRegex() == true {
            //이메일, 비번 모두 조건에 맞음(아직 중복체크는 안했음)
            Auth.auth().createUser(withEmail: emails, password: passwords) { (user, error) in
                if user != nil {
                    //success
                    guard let uid = user?.user.uid else { return }
                    UserSingleton.shared.uid = uid
//                    self.present(Method.alert(type: .RegisterSuccess), animated: true)
//                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "TwitchViewController")
//                    self.navigationController?.pushViewController(newViewController, animated: true)
                    self.dismiss(animated: true, completion: {
                        try! Auth.auth().signOut()
                    })
                }else {
                    //fail(아이디 중복말고없을듯?)
                    self.present(Method.alert(type: .RegisterError), animated: true)
                }
            }
        }else {
            emailErrorLabel.text = "잘못된 이메일 주소입니다."
            passwordErrorLabel.text = "최소8자 (대 소문자, 숫자)"
        }
    }
}

extension EmailViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField, emailTextField.text?.count != 0, emailTextField.text?.emailRegex() == false {
            emailErrorLabel.text = "잘못된 이메일 주소입니다."
        }else if textField == passwordTextField, passwordTextField.text?.count != 0, passwordTextField.text?.passwordRegex() == false {
            passwordErrorLabel.text = "최소8자 (대 소문자, 숫자, 특수문자)"
        }
    }
}
