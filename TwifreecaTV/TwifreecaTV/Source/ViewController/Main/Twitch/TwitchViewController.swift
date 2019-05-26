//
//  TwitchViewController.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 21/05/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import UIKit
import Firebase

class TwitchViewController: UIViewController {

    @IBOutlet weak var testLabel: UILabel!
    
//    private let afreecaSearch: AfreecaSearchType = AfreecaSearchService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testLabel.text = Auth.auth().currentUser?.uid
        
        setupInitiailize()
        
//        afreecaSearch.searchAfreecaBJ(name: "서준석") { (result) in
//            switch result {
//            case .success(let value):
//                print("successssss = \(value)")
//            case .failure(let error):
//                print("errororororor = \(error)")
//            }
//        }
    }
    
    func setupInitiailize() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func testss(_ sender: Any) {
        try! Auth.auth().signOut()
    }
    
}
