//
//  AfreecaSearchViewController.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 22/05/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import UIKit

class AfreecaSearchViewController: UIViewController {
    
    
    @IBOutlet weak var searchTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialize()
        
    }
    
    func setupInitialize() {
        let string = NSLocalizedString("아프리카TV 검색", comment: "Some comment")
        searchTextField.attributedPlaceholder = NSAttributedString(string: string ,attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        searchTextField.delegate = self
        searchTextField.returnKeyType = .search
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AfreecaSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("ssss")
        return true
    }
}
