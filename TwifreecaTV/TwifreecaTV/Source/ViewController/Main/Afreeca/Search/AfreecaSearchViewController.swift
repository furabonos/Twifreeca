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

class AfreecaSearchViewController: UIViewController {
    
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    
    private var activityView: NVActivityIndicatorView!
    
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
        
    }
    
    func setupInitialize() {
        let string = NSLocalizedString("아프리카TV 검색", comment: "Some comment")
        searchTextField.attributedPlaceholder = NSAttributedString(string: string ,attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        searchTextField.delegate = self
        searchTextField.returnKeyType = .search
        
        collectionView.delegate = self
        collectionView.dataSource = self
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
        self.view.endEditing(true)
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
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let bjName = searchData[indexPath.row]?.bjname else { return }
        guard let bjId = searchData[indexPath.row]?.bjid else { return }
        guard let profileUrl = searchData[indexPath.row]?.profileurl else { return }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
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
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//            return CGSize(width: view.frame.width, height: 250)
//    }
}

extension AfreecaSearchViewController: CellDelegate {
    func addDatabase(cell: SearchCollectionViewCell) {
        print(searchData[cell.addBtn.tag]?.bjname)
    }
}
