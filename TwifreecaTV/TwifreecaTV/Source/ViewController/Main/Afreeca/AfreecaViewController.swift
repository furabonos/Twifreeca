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
import AMShimmer

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
    var broadNumArr = Array<String>()
    
    var bjNameArr = Array<String>()
    var thumbnailArr = Array<String>()
    var titleArr = Array<String>()
    
    var onOff = String()
    
    var checkBool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupInitialize()
        collectionView.register(
            UINib(nibName: "AfreecaCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "AfreecaCollectionViewCell"
        )
        self.checkLive2(name: "170110") { (result) in
            print("ssss = \(result)")
        }
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
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshs), for: .valueChanged)
        refreshControl.isUserInteractionEnabled = false
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
        self.tabBarController?.tabBar.barTintColor = UIColor(red: 7/255, green: 61/255, blue: 167/255, alpha: 1.0)
    }
    
    @objc func refreshs(refreshControl: UIRefreshControl) {
        self.nameArr.removeAll()
        self.idArr.removeAll()
        self.urlArr.removeAll()
        fetchBjData()
        refreshControl.endRefreshing()
        
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
    
    func checkLive2(name: String, completion: @escaping (Array<String>) -> ()) {
        var checkLiveArr = Array<String>()
        let afreecaRef = Database.database().reference().child("AfreecaLive").child(name)
        afreecaRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                checkLiveArr.append("OFF")
                completion(checkLiveArr)
                return
            }
            let bjName = dictionaries["name"] as! String
            let thumbnailURL = dictionaries["thumbnail"] as! String
            let bjTitle = dictionaries["title"] as! String
            let broadLink = dictionaries["link"] as! String
            print(bjName,thumbnailURL,bjTitle, broadLink)
            checkLiveArr.append("ON")
            checkLiveArr.append(bjName)
            checkLiveArr.append(thumbnailURL)
            checkLiveArr.append(bjTitle)
            checkLiveArr.append(broadLink)
            completion(checkLiveArr)
//            dictionaries.forEach({ (key, value) in
//                guard let dictionary = value as? [String: Any] else { return }
//                let bjName = dictionary["name"] as! String
//                let thumbnailURL = dictionary["thumbnail"] as! String
//                let bjTitle = dictionary["title"] as! String
//
//                print("ffff = \(bjName)")
//
//                self.bjNameArr.append(bjName)
//                self.thumbnailArr.append(thumbnailURL)
//                self.titleArr.append(bjTitle)
            
//            })
//            print("으악 = \(self.bjNameArr[0])")
//            print("으악 = \(self.thumbnailArr[0])")
//            print("으악 = \(self.titleArr[0])")
        
            
        })
        
    }
    
    func deleteBj(bj: String) {
        let alertController = UIAlertController(title: "",message: "리스트에서 삭제하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let cancelButton = UIAlertAction(title: "삭제", style: UIAlertAction.Style.destructive) { (ac) in
            let twitchRef = Database.database().reference().child((Auth.auth().currentUser?.uid)!).child("Afreeca").child("\(bj)")
            twitchRef.removeValue()
            self.present(Method.alert(type: .DelSuccess), animated: true, completion: {
                self.collectionView.isHidden = true
                self.view.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1.0)
                self.navigationController?.navigationBar.backgroundColor = .white
                self.nameArr.removeAll()
                self.idArr.removeAll()
                self.urlArr.removeAll()
                self.fetchBjData()
            })
        }
        let cancelButton2 = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: nil)
        alertController.addAction(cancelButton)
        alertController.addAction(cancelButton2)
        self.present(alertController, animated: true)
        
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
            DispatchQueue.main.async {
                KingfisherManager.shared.cache.clearMemoryCache()
                KingfisherManager.shared.cache.clearDiskCache()
                KingfisherManager.shared.cache.cleanExpiredDiskCache()
            }
            cell.delegate = self
            cell.delBtn.tag = indexPath.row
            checkLive2(name: self.idArr[indexPath.row]) { (result) in
                switch result[0] {
                case "ON":
                    print("ONONON")
                    cell.onOffLabel.text = "onAir"
                    cell.onOffLabel.backgroundColor = .red
                    cell.onOffLabel.textColor = .white
                    cell.mrLabel.text = result[3]
                    cell.broadcastLabel.isHidden = true
                    cell.bjImageView.kf.setImage(with: URL(string: self.makeURL(urls: result[2])))
                case "OFF":
                    print("OFFOFFOFF")
                    cell.onOffLabel.text = "OFF"
                    cell.onOffLabel.backgroundColor = .white
                    cell.onOffLabel.textColor = .black
                    cell.mrLabel.text = "현재 방송중이지 않습니다."
                    cell.broadcastLabel.isHidden = true
                    cell.bjImageView.kf.setImage(with: URL(string: self.makeURL(urls: self.urlArr[indexPath.row])))
                default:
                    break
                }
                cell.bjLabel.text = "\(self.nameArr[indexPath.row])(\(self.idArr[indexPath.row]))"
                cell.delBtn.isHidden = false
                AMShimmer.stop(for: cell.bjImageView)
                AMShimmer.stop(for: cell.onOffLabel)
                AMShimmer.stop(for: cell.bjLabel)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        checkLive2(name: self.idArr[indexPath.row]) { (result) in
            switch result[0] {
            case "ON":
                print(result[4])
                print(result[4].replaces(target: "http://play.afreecatv.com/", withString: "").replaces(target: "\(self.idArr[indexPath.row])/", withString: ""))
            default:
                break
            }
        }
//        checkLive(name: self.idArr[indexPath.row]) { (result) in
//            switch result[0] {
//            case "ON":
//                print("fdfsdfsdfsdfsdfsd = \(result[2])")
//                var sss = result[2]
//                var sss2 = sss.replaces(target: "liveimg.afreecatv.com/", withString: "")
//                var broadNum = sss2.replaces(target: ".jpg", withString: "")
//                print(broadNum)
//                let afreecaScheme = URL(string: "afreeca://player/live?user_id=\(self.idArr[indexPath.row])&broad_no=\(broadNum)")!
//
//                if UIApplication.shared.canOpenURL(afreecaScheme) {
//                    UIApplication.shared.open(afreecaScheme) // 오픈을 사용하면 화이트 리스트 없어도 들어갈 수 이씅나,화이트 리스트를 활용하자 !
//                }else {
//                    self.present(Method.alert(type: .AfreecaStore), animated: true)
//                }
//            default:
//                break
//            }
//        }
    }
}

extension AfreecaViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 135)
    }
    
}

extension AfreecaViewController: DeleteBjDelegate {
    func delDatabase(cell: AfreecaCollectionViewCell) {
        self.deleteBj(bj: self.nameArr[cell.delBtn.tag])
    }
}
