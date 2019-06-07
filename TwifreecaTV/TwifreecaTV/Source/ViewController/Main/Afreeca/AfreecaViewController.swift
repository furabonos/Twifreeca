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
import NVActivityIndicatorView

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
    
    private var activityView: NVActivityIndicatorView!
    private let afreecaService: AfreecaSearchType = AfreecaSearchService()
    
    
    var nameArr = Array<String>()
    var idArr = Array<String>()
    var urlArr = Array<String>()
    
    var onOff = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupInitialize()
        collectionView.register(
            UINib(nibName: "AfreecaCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "AfreecaCollectionViewCell"
        )
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupInitialize()
        fetchBjData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.nameArr.removeAll()
        self.idArr.removeAll()
        self.urlArr.removeAll()
    }
    
    func setupInitialize() {
        setupActivityIndicator()
        
        backgroundImageView.isHidden = true
        followLabel.isHidden = true
        
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
        
    }
    
    func fetchBjData() {
//        self.activityView.startAnimating()
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
            if self.nameArr.count == 0 {
                self.collectionView.isHidden = true
                self.backgroundImageView.isHidden = false
                self.followLabel.isHidden = false
            }else {
                self.collectionView.isHidden = false
                self.backgroundImageView.isHidden = true
                self.followLabel.isHidden = true
            }
            self.collectionView.reloadData()
            print(self.urlArr)
//            self.activityView.stopAnimating()
        })
        
    }
    func checkLive(name: String, completion: @escaping (Array<String>) ->  ()){
        var resultArr = Array<String>()
        afreecaService.liveAfreecaBJ(name: name) { (result) in
            switch result {
            case .success(let value):
                resultArr.append(value.streamNow)
                resultArr.append(value.streamTitle)
                resultArr.append(value.streamImg)
                completion(resultArr)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    private func setupActivityIndicator() {
        activityView = NVActivityIndicatorView(frame: CGRect(x: self.view.center.x - 50, y: self.view.center.y - 50, width: 100, height: 100), type: NVActivityIndicatorType.ballBeat, color: UIColor(red: 0/255.0, green: 132/255.0, blue: 137/255.0, alpha: 1), padding: 25)
        
        activityView.backgroundColor = .white
        activityView.layer.cornerRadius = 10
        self.collectionView.addSubview(activityView)
    }
    
    func makeURL(urls: String) -> String {
        return "http://\(urls)"
    }
    
}

extension AfreecaViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.nameArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AfreecaCollectionViewCell", for: indexPath) as! AfreecaCollectionViewCell
       
        if self.nameArr.count > 0 {
            cell.bjLabel.text = self.nameArr[indexPath.row]
            checkLive(name: self.idArr[indexPath.row]) { (result) in
                switch result[0] {
                case "ON":
                    cell.onOffLabel.text = "onAir"
                    cell.onOffLabel.backgroundColor = .red
                    cell.onOffLabel.textColor = .white
                    cell.broadcastLabel.text = result[1]

                case "OFF":
                    cell.onOffLabel.text = "OFF"
                    cell.bjImageView.kf.setImage(with: URL(string: self.makeURL(urls: self.urlArr[indexPath.row])))
                    cell.broadcastLabel.text = "현재 방송중이지 않습니다."
                default:
                    break
                }
            }
//            cell.bjLabel.text = self.nameArr[indexPath.row]
//            cell.bjImageView.kf.setImage(with: URL(string: makeURL(urls: self.urlArr[indexPath.row])))
        }
        
        return cell
    }
}

extension AfreecaViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 135)
    }
    
}
