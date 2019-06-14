//
//  TwitchSearchCell.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 13/06/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import UIKit
import MarqueeLabel
import SnapKit

protocol TwitchCellDelegate: class {
    func addDatabase()
}

class TwitchSearchCell: UICollectionViewCell {

    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var streamerImageView: UIImageView!
    @IBOutlet weak var streamerNameLabel: UILabel!
    
    lazy var mrLabel: MarqueeLabel = {
        var label = MarqueeLabel()
        label.text = ""
        label.marqueeType = .MLContinuous
        label.fadeLength = 10.0
        label.textColor = .white
        return label
    }()
    
    weak var delegate: TwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       setupInitialize()
    }
    
    func setupInitialize() {
        self.contentView.addSubview(mrLabel)
        mrLabel.snp.makeConstraints { (m) in
            m.top.equalTo(streamerNameLabel.snp.bottom).offset(10)
            m.left.equalTo(streamerNameLabel.snp.left)
            m.height.equalTo(streamerNameLabel.snp.height)
            m.right.equalTo(self.contentView.snp.right).offset(-10)
        }
    }
    
    @IBAction func addAction(_ sender: Any) {
        delegate?.addDatabase()
    }
    
}
