//
//  AfreecaSearchViewController.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 22/05/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import NVActivityIndicatorView
import Firebase
import Toast_Swift

class AfreecaSearchViewController: UIViewController {
    
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    
    private var activityView: NVActivityIndicatorView!
    private var refreshController = UIRefreshControl()
    
    var searchData: [BjListInfo?] = []
    private let afreecaService: AfreecaSearchType = AfreecaSearchService()
    
    
    
     lazy var cancelBtn: UIButton = {
       var btn = UIButton()
        btn.setTitle("취소", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        btn.backgroundColor = UIColor(red: 48/255, green: 98/255, blue: 255/255, alpha: 1.0)
        return btn
    }()
    
    lazy var backgroundImageView: UIImageView = {
        var iv = UIImageView()
        iv.image = UIImage(named: "inspection2")
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialize()
        checkBJ(checkName: "서준석(gotkdlzh)")
    }
    
    func checkBJ(checkName: String) {
        var rere = String()
        var nameArr = Array<String>()
        
        let afreecaRef = Database.database().reference().child((Auth.auth().currentUser?.uid)!).child("Afreeca")
        afreecaRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                let username = dictionary["name"] as! String
                nameArr.append(username)
            })
            if nameArr.contains(checkName) {
                print("YYYYYYYess")
                rere = "ffff"
            }else {
                rere = "zzzz"
                print("NNNNNNNNNNNNo")
            }
        })
        print("rere = \(rere)")
    }
    
    func setupInitialize() {
        let string = NSLocalizedString("아프리카TV 검색", comment: "Some comment")
        searchTextField.attributedPlaceholder = NSAttributedString(string: string ,attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        searchTextField.delegate = self
        searchTextField.returnKeyType = .search
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.register(
            UINib(nibName: "SearchCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "SearchCollectionViewCell"
        )
        
        collectionView.isHidden = true
        
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { (m) in
            m.width.equalTo(100)
            m.height.equalTo(100)
            m.centerX.equalTo(view.snp.centerX)
            m.centerY.equalTo(view.snp.centerY)
        }
        
        view.addSubview(cancelBtn)
        cancelBtn.isHidden = true
        cancelBtn.snp.makeConstraints { (m) in
            m.width.equalTo(50)
            m.height.equalTo(30)
            m.top.equalTo(textView.snp.top).offset(15)
            m.left.equalTo(textView.snp.left).offset(8)
        }
        
        setupActivityIndicator()
    }
    
    @objc func refresh() {
        print("rererererererererererererererererer")
        self.refreshController.endRefreshing()
    }
    
    private func setupActivityIndicator() {
        activityView = NVActivityIndicatorView(frame: CGRect(x: self.view.center.x - 50, y: self.view.center.y - 50, width: 100, height: 100), type: NVActivityIndicatorType.ballBeat, color: UIColor(red: 0/255.0, green: 132/255.0, blue: 137/255.0, alpha: 1), padding: 25)
        
        activityView.backgroundColor = .white
        activityView.layer.cornerRadius = 10
        self.view.addSubview(activityView)
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
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AfreecaSearchViewController: UITextFieldDelegate {
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
            self.backgroundImageView.isHidden = true
            self.activityView.startAnimating()
            afreecaService.searchAfreecaBJ(name: searchTextField.text!) { (result) in
                switch result {
                case .success(let value):
                    print(value)
                    self.searchData = value.bjlist
                    print(self.searchData)
                    self.collectionView.reloadData()
                    self.collectionView.isHidden = false
                    self.activityView.stopAnimating()
                case .failure(let error):
                    print(error)
                    self.activityView.stopAnimating()
                    self.collectionView.makeToast("다시 시도해주세요.", duration: 3.0, position: .center)
                }
            }
        }else {
            self.present(Method.alert(type: .SearchError), animated: true)
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cancelBtn.isHidden = false
        textField.snp.remakeConstraints { (m) in
            m.top.equalTo(textView.snp.top).offset(15)
            m.right.equalTo(textView.snp.right).offset(8)
            m.height.equalTo(30)
            m.left.equalTo(textView.snp.left).offset(70)
        }
    }
    
    func makeBroadcastMent(ment: String) -> String {
        if ment == "" {
            return "방송국 소개가 없습니다."
        }
        return ment
    }
    
    func makeURL(urls: String) -> String {
        return "http://\(urls)"
    }
}

extension AfreecaSearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as! SearchCollectionViewCell
        if searchData.count > 0 {
            cell.delegate = self
            cell.addBtn.tag = indexPath.row
            cell.bjNameLabel.text = searchData[indexPath.row]?.bjname
//            cell.broadcastMent.text = searchData[indexPath.row]?.broadcastMent
            cell.broadcastMent.text = makeBroadcastMent(ment: searchData[indexPath.row]?.broadcastMent ?? "")
            cell.broadcastName.text = searchData[indexPath.row]?.broadcastName
            cell.bjProfileImageView.kf.setImage(with: URL(string: makeURL(urls: searchData[indexPath.row]?.profileurl ?? "")))
        }
        return cell
    }
}

extension AfreecaSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 125)
    }
    
}

extension AfreecaSearchViewController: CellDelegate {
    func addDatabase(cell: SearchCollectionViewCell) {
        guard let bjName = searchData[cell.addBtn.tag]?.bjname else { return }
        guard let bjId = searchData[cell.addBtn.tag]?.bjid else { return }
        guard let profileUrl = searchData[cell.addBtn.tag]?.profileurl else { return }
        var nameArr = Array<String>()
        print("0703 = \(bjName)(\(bjId))")
        var displayName = "\(bjName)(\(bjId))"
        let afreecaRef = Database.database().reference().child((Auth.auth().currentUser?.uid)!).child("Afreeca")
        afreecaRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                let afreecaRefs = Database.database().reference().child((Auth.auth().currentUser?.uid)!)
                let ref = afreecaRefs.child("Afreeca").child(bjName)
                let values = ["name": bjName,
                              "id": bjId,
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
            if nameArr.contains(bjName) {
                self.present(Method.alert(type: .FollowOverlap), animated: true)
                
            }else {
                let afreecaRefs = Database.database().reference().child((Auth.auth().currentUser?.uid)!)
                let ref = afreecaRefs.child("Afreeca").child(bjName)
                let values = ["name": bjName,
                              "id": bjId,
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
        })
        
        
    }
}
