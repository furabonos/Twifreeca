//
//  TwitchViewController.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 21/05/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import UIKit
import Firebase
import Toast_Swift
import Kingfisher

class TwitchViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var nameArr = Array<String>()
    var idArr = Array<String>()
    var urlArr = Array<String>()
    
    lazy var followLabel: UILabel = {
        var label = UILabel()
        label.text = "아직 팔로우한 스트리머가 없습니다."
        label.textColor = .white
        label.backgroundColor = .black
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var searchData: [StreamerLiveInfo?] = []
    private let twitchService: TwitchSearchType = TwitchSearchService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupInitialize()
        fetchStreamerData()
//        resetDefaults()
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.nameArr.removeAll()
        self.idArr.removeAll()
        self.urlArr.removeAll()
    }
    
    func setupInitialize() {
        self.followLabel.isHidden = true
        collectionView.register(
            UINib(nibName: "TwitchCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "TwitchCollectionViewCell"
        )
        view.addSubview(followLabel)
        followLabel.snp.makeConstraints { (m) in
            m.width.equalTo(140)
            m.height.equalTo(30)
            m.center.equalTo(collectionView.snp.center)
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshs), for: .valueChanged)
        refreshControl.isUserInteractionEnabled = false
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
        
    }
    
    @objc func refreshs(refreshControl: UIRefreshControl) {
        self.nameArr.removeAll()
        self.idArr.removeAll()
        self.urlArr.removeAll()
        fetchStreamerData()
        refreshControl.endRefreshing()
        
    }
    
    func fetchStreamerData() {
        //        self.activityView.startAnimating()
        let afreecaRef = Database.database().reference().child((Auth.auth().currentUser?.uid)!).child("Twitch")
        afreecaRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                let streamerName = dictionary["name"] as! String
                let streamerId = dictionary["id"] as! String
                let profileUrl = dictionary["profileurl"] as! String
                
                self.nameArr.append(streamerName)
                self.idArr.append(streamerId)
                self.urlArr.append(profileUrl)
            })
            if self.nameArr.count == 0 {
                self.collectionView.isHidden = true
//                self.backgroundImageView.isHidden = false
                self.followLabel.isHidden = false
            }else {
                self.collectionView.isHidden = false
//                self.backgroundImageView.isHidden = true
                self.followLabel.isHidden = true
            }
            self.collectionView.reloadData()
            print(self.urlArr)
            //            self.activityView.stopAnimating()
        })
        
    }
    
    func checkLive(name: String, completion: @escaping (Array<String>) ->  ()){
        var resultArr = Array<String>()
        twitchService.liveTwitchStreamer(name: name) { (result) in
            switch result {
            case .success(let value):
                if value.data.isEmpty {
                    resultArr.append("OFF")
                }else {
                    resultArr.append("ON")
                    resultArr.append(value.data[0].title)
                    resultArr.append(value.data[0].thumbnailUrl)
                    resultArr.append("\(value.data[0].viewerCount)")
                }
                completion(resultArr)
            case .failure(let error):
                print("ssibal")
            }
        }
        
    }
    
    func makeCellImage(str: String) -> String {
        var c1 = str.replaces(target: "%", withString: "")
        var c2 = c1.replaces(target: "{width}", withString: "100")
        var c3 = c2.replaces(target: "{height}", withString: "70")
        return c3
    }
    
//    @IBAction func fdsfsdfsd(_ sender: Any) {
//        try! Auth.auth().signOut()
//    }
    
    @IBAction func logOut(_ sender: Any) {
        try! Auth.auth().signOut()
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let storyboard = UIStoryboard(name: "Register", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        
        let navEditorViewController: UINavigationController = UINavigationController(rootViewController: initialViewController)
        
        appDelegate.window?.rootViewController = navEditorViewController
        
    }
    
    
}

extension TwitchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.nameArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TwitchCollectionViewCell", for: indexPath) as! TwitchCollectionViewCell
        if self.nameArr.count > 0 {
            DispatchQueue.main.async {
                KingfisherManager.shared.cache.clearMemoryCache()
                KingfisherManager.shared.cache.clearDiskCache()
                KingfisherManager.shared.cache.cleanExpiredDiskCache()
            }
            cell.streamerImageView.image = nil
            cell.streamerNameLabel.text = "\(self.nameArr[indexPath.row])(\(self.idArr[indexPath.row]))"
            checkLive(name: self.idArr[indexPath.row]) { (result) in
                switch result[0] {
                case "ON":
                    print("fjdfjlsdkfjkdlsfjldskfjdlskfjsdkl = \(self.makeCellImage(str: result[2]))")
                    cell.streamMrLabel.text = result[1]
                    cell.streamerImageView.kf.setImage(with: URL(string: self.makeCellImage(str: result[2])))
                    cell.redCircle.isHidden = false
                    cell.viewerLabel.text = result[3]
                case "OFF":
                    cell.streamMrLabel.text = "현재 방송중이지 않습니다."
                    cell.streamerImageView.kf.setImage(with: URL(string: self.urlArr[indexPath.row]))
                    cell.redCircle.isHidden = true
                    cell.viewerLabel.isHidden = true
                default:
                    break
                }
                
            }
        }
        return cell
    }
    
    
}

extension TwitchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
}
