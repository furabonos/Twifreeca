//
//  AfreecaViewController.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 21/05/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import UIKit
import Firebase
import SnapKit
import Kingfisher

class AfreecaViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var backgroundImageView: UIImageView = {
        var iv = UIImageView()
        iv.image = UIImage(named: "diagnostic")
        return iv
    }()
    
    lazy var followLabel: UILabel = {
        var label = UILabel()
        label.text = "아직 팔로우한 BJ가 없습니다."
        label.textColor = .black
        label.backgroundColor = .white
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var nameArr = Array<String>()
    var idArr = Array<String>()
    var urlArr = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //AfreecaCollectionViewCell
        collectionView.register(
            UINib(nibName: "AfreecaCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "AfreecaCollectionViewCell"
        )
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupInitialize()
    }
    
    func setupInitialize() {
        fetchBjData()
        
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { (m) in
            m.width.equalTo(100)
            m.height.equalTo(100)
            m.centerX.equalTo(view.snp.centerX)
            m.centerY.equalTo(view.snp.centerY)
        }
        
        view.addSubview(followLabel)
        followLabel.snp.makeConstraints { (m) in
            m.width.equalTo(140)
            m.height.equalTo(30)
            m.top.equalTo(backgroundImageView.snp.bottom)
//            m.left.equalTo(backgroundImageView.snp.left)
            m.centerX.equalTo(view.snp.centerX)
        }
        
        if self.nameArr.count == 0 {
            self.collectionView.isHidden = true
            self.backgroundImageView.isHidden = false
            self.followLabel.isHidden = false
        }else {
            self.collectionView.isHidden = false
            self.backgroundImageView.isHidden = true
            self.followLabel.isHidden = true
        }
        
    }
    
    func fetchBjData() {
        var rere = String()
//        var nameArr = Array<String>()
        
        let afreecaRef = Database.database().reference().child((Auth.auth().currentUser?.uid)!).child("Afreeca")
        afreecaRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                let bjName = dictionary["name"] as! String
                let bjId = dictionary["id"] as! String
                let profileUrl = dictionary["profileurl"] as! String
                
                self.nameArr.append(bjName)
                self.idArr.append(bjId)
                self.urlArr.append(profileUrl)
            })
            
        })
        
    }
    
}

extension AfreecaViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AfreecaCollectionViewCell", for: indexPath) as! AfreecaCollectionViewCell
       
        return cell
    }
}

extension AfreecaViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 125)
    }
    
}
