//
//  TwitchSearchViewController.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 11/06/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import Kingfisher
import SnapKit
import NVActivityIndicatorView
import Toast_Swift

class TwitchSearchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var textView: UIView!
    
    private var activityView: NVActivityIndicatorView!
    
    lazy var imageView: UIImageView = {
        var iv = UIImageView()
        iv.image = UIImage(named: "twitchlogo2")
        return iv
    }()
    
    lazy var mentLabel: UILabel = {
        var label = UILabel()
        label.text = "검색결과가 없습니다"
        label.textColor = .gray
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var searchData: [StreamerInfo?] = []
    var videoData: [TwitchVideoInfo?] = []
    private let twitchService: TwitchSearchType = TwitchSearchService()
    
    lazy var cancelBtn: UIButton = {
        var btn = UIButton()
        btn.setTitle("취소", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        btn.backgroundColor = UIColor(red: 89/255, green: 57/255, blue: 154/255, alpha: 1.0)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //gp6ddqo2btpzj4krg78e3i75blsnpw
        setupInitialize()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        cancelBtn.isHidden = true
        self.view.endEditing(true)
        searchTextField.snp.remakeConstraints { (m) in
            m.top.equalTo(textView.snp.top).offset(15)
            m.right.equalTo(textView.snp.right).offset(8)
            m.height.equalTo(30)
            m.left.equalTo(textView.snp.left).offset(8)
        }
    }
    
    func setupInitialize() {
        let string = NSLocalizedString("트위치TV 검색", comment: "Some comment")
        searchTextField.attributedPlaceholder = NSAttributedString(string: string ,attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        searchTextField.delegate = self
        searchTextField.returnKeyType = .search
        
        view.addSubview(cancelBtn)
        cancelBtn.isHidden = true
        cancelBtn.snp.makeConstraints { (m) in
            m.width.equalTo(50)
            m.height.equalTo(30)
            m.top.equalTo(textView.snp.top).offset(15)
            m.left.equalTo(textView.snp.left).offset(8)
        }
        
        collectionView.register(
            UINib(nibName: "TwitchSearchCell", bundle: nil),
            forCellWithReuseIdentifier: "TwitchSearchCell"
        )
        
        collectionView.register(UINib(nibName: "TwitchHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TwitchHeader")
        
        
        collectionView.addSubview(imageView)
        imageView.snp.makeConstraints { (m) in
            m.width.equalTo(100)
            m.height.equalTo(100)
            m.center.equalTo(collectionView.snp.center)
        }

        collectionView.addSubview(mentLabel)
        mentLabel.snp.makeConstraints { (m) in
            m.width.equalTo(120)
            m.height.equalTo(20)
            m.top.equalTo(imageView.snp.bottom).offset(5)
            m.centerX.equalTo(view.snp.centerX)
        }

        imageView.isHidden = true
        mentLabel.isHidden = true
        
        setupActivityIndicator()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOutsideCollectionView(recognizer:)))
        tap.numberOfTapsRequired = 1
        self.collectionView.addGestureRecognizer(tap)
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore
        {
            print("Not first launch.")
        }
        else
        {
            print("First launch")
            self.present(Method.alert(type: .FirstLaunch), animated: true)
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        
    }
    
    func searchInfo() {
        
    }
    
    @objc func didTapOutsideCollectionView(recognizer: UITapGestureRecognizer){
        cancelBtn.isHidden = true
        self.view.endEditing(true)
        searchTextField.snp.remakeConstraints { (m) in
            m.top.equalTo(textView.snp.top).offset(15)
            m.right.equalTo(textView.snp.right).offset(8)
            m.height.equalTo(30)
            m.left.equalTo(textView.snp.left).offset(8)
        }
    }
    
    @objc func cancelAction() {
        cancelBtn.isHidden = true
        self.view.endEditing(true)
        searchTextField.snp.remakeConstraints { (m) in
            m.top.equalTo(textView.snp.top).offset(15)
            m.right.equalTo(textView.snp.right).offset(8)
            m.height.equalTo(30)
            m.left.equalTo(textView.snp.left).offset(8)
        }
    }
    
    private func setupActivityIndicator() {
        activityView = NVActivityIndicatorView(frame: CGRect(x: self.view.center.x - 50, y: self.view.center.y - 50, width: 100, height: 100), type: NVActivityIndicatorType.ballBeat, color: UIColor(red: 0/255.0, green: 132/255.0, blue: 137/255.0, alpha: 1), padding: 25)
        
        activityView.backgroundColor = .clear
        activityView.layer.cornerRadius = 10
        self.view.addSubview(activityView)
    }
    
    func makeCellImage(str: String) -> String {
        var c1 = str.replaces(target: "%", withString: "")
        var c2 = c1.replaces(target: "{width}", withString: "100")
        var c3 = c2.replaces(target: "{height}", withString: "70")
        return c3
    }

}

extension TwitchSearchViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.cancelBtn.isHidden = false
        textField.snp.remakeConstraints { (m) in
            m.top.equalTo(textView.snp.top).offset(15)
            m.right.equalTo(textView.snp.right).offset(8)
            m.height.equalTo(30)
            m.left.equalTo(textView.snp.left).offset(70)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.searchTextField.resignFirstResponder()
        cancelBtn.isHidden = true
        
        searchTextField.snp.remakeConstraints { (m) in
            m.top.equalTo(textView.snp.top).offset(15)
            m.right.equalTo(textView.snp.right).offset(8)
            m.height.equalTo(30)
            m.left.equalTo(textView.snp.left).offset(8)
        }
        
        if (searchTextField.text?.count)! > 0 {
//            self.backgroundImageView.isHidden = true
//            self.activityView.startAnimating()
            twitchService.searchTwitchStreamer(name: searchTextField.text!) { (result) in
                switch result {
                case .success(let value):
                    self.searchData = value.data
                    if value.data.isEmpty == false{
                        self.twitchService.searchTwitchVideos(name: self.searchData[0]?.id ?? "", completion: { (result) in
                            switch result {
                            case .success(let value):
                                self.videoData = value.data
                                self.imageView.isHidden = true
                                self.mentLabel.isHidden = true
                                self.collectionView.reloadData()
                            case .failure(let error):
                                print(error)
                                self.collectionView.makeToast("다시 시도해주세요.", duration: 3.0, position: .center)
                            }
                        })
                    }else {
                        self.imageView.isHidden = false
                        self.mentLabel.isHidden = false
                        self.videoData.removeAll()
                        self.collectionView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                    self.collectionView.makeToast("다시 시도해주세요.", duration: 3.0, position: .center)
                }
            }
        }else {
            self.present(Method.alert(type: .SearchError), animated: true)
        }
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TwitchHeader", for: indexPath) as! TwitchHeader
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if indexPath.section == 0 {
                header.headerLabel.text = "채널"
//                return header
            } else {
                header.headerLabel.text = "동영상"
            }
        default:
            assert(false, "Unexpected element kind")
        }
        
        return header
    }
}

extension TwitchSearchViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return searchData.count
        }else {
            return videoData.count
        }
//        return searchData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TwitchSearchCell", for: indexPath) as! TwitchSearchCell
        if indexPath.section == 0 {
            if searchData.count > 0 {
                cell.delegate = self
                cell.addBtn.isHidden = false
                cell.streamerImageView.kf.setImage(with: URL(string: searchData[indexPath.row]?.profileImageUrl ?? ""))
                cell.streamerNameLabel.text = "\(searchData[indexPath.row]!.displayName)(\(searchData[indexPath.row]!.login))"
                cell.mrLabel.text = searchData[indexPath.row]!.description
            }
        }else {
            if videoData.count > 0 {
                cell.addBtn.isHidden = true
                cell.streamerNameLabel.text = videoData[indexPath.row]?.userName
                cell.mrLabel.text = videoData[indexPath.row]?.title
                cell.streamerImageView.kf.setImage(with: URL(string: makeCellImage(str: (videoData[indexPath.row]?.thumbnailUrl)!)))
            }
        }
        return cell
    }
    
}

extension TwitchSearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if searchData.count > 0 {
            return CGSize(width: view.frame.width, height: 40)
        }else {
            return CGSize(width: view.frame.width, height: 0)
        }
    }
    
}

extension TwitchSearchViewController: TwitchCellDelegate {
    func addDatabase() {
        self.activityView.startAnimating()
        guard let name = self.searchData[0]?.displayName else { return }
        guard let id = self.searchData[0]?.login else { return }
        guard let profileUrl = self.searchData[0]?.profileImageUrl else { return }
        print(name)
        print(id)
        print(profileUrl)
        var nameArr = Array<String>()
        
        let twitchRef = Database.database().reference().child((Auth.auth().currentUser?.uid)!).child("Twitch")
    
        twitchRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                let twitchRefs = Database.database().reference().child((Auth.auth().currentUser?.uid)!)
                let ref = twitchRefs.child("Twitch").child(name)
                let values = ["name": name,
                              "id": id,
                              "profileurl": profileUrl] as [String: Any]
                ref.updateChildValues(values){ (err, ref) in
                    if let err = err {
                        //실패
                        self.present(Method.alert(type: .FollowError), animated: true)
                    }
                    //성공
                    self.present(Method.alert(type: .FollowSuccess), animated: true)
                }
                return
            }
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                let username = dictionary["name"] as! String
                nameArr.append(username)
            })
            if nameArr.contains(name) {
                self.present(Method.alert(type: .FollowOverlap), animated: true)
//                self.activityView.stopAnimating()
            }else {
                let afreecaRefs = Database.database().reference().child((Auth.auth().currentUser?.uid)!)
                let ref = afreecaRefs.child("Twitch").child(name)
                let values = ["name": name,
                              "id": id,
                              "profileurl": profileUrl] as [String: Any]
                ref.updateChildValues(values){ (err, ref) in
                    if let err = err {
                        //실패
                        self.present(Method.alert(type: .FollowError), animated: true)
                    }
                    //성공
                    self.present(Method.alert(type: .FollowSuccess), animated: true)
                }

            }
            self.activityView.stopAnimating()
        })
        
    }
}




