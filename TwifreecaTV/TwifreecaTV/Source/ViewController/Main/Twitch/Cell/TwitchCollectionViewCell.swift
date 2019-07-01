//
//  TwitchCollectionViewCell.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 17/06/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import UIKit
import SnapKit
import MarqueeLabel

protocol DeleteStreamerDelegate: class {
    func delDatabase(cell: TwitchCollectionViewCell)
}

class TwitchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var redCircle: UIImageView! 
    @IBOutlet weak var streamerImageView: UIImageView!
    @IBOutlet weak var streamerNameLabel: UILabel!
    
    lazy var streamMrLabel: MarqueeLabel = {
        var label = MarqueeLabel()
        label.text = ""
        label.marqueeType = .MLContinuous
        label.fadeLength = 10.0
        label.textColor = .white
        return label
    }()
    
    lazy var viewerLabel: UILabel = {
        var label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 10)
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    @IBOutlet weak var delBtn: UIButton!
    weak var delegate: DeleteStreamerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitialize()
    }
    
    func setupInitialize() {
        print("fcd")
        self.contentView.addSubview(streamMrLabel)
        streamMrLabel.snp.makeConstraints { (m) in
            m.top.equalTo(streamerNameLabel.snp.bottom).offset(10)
            m.left.equalTo(streamerNameLabel.snp.left)
            m.height.equalTo(streamerNameLabel.snp.height)
            m.right.equalTo(self.contentView.snp.right).offset(-10)
        }
        redCircle.layer.cornerRadius = redCircle.frame.width / 2
        redCircle.clipsToBounds = true
        
        self.contentView.addSubview(viewerLabel)
        viewerLabel.snp.makeConstraints { (m) in
            m.height.equalTo(redCircle.snp.height)
            m.top.equalTo(redCircle.snp.top)
            m.left.equalTo(redCircle.snp.right).offset(5)
            m.right.equalTo(streamerImageView.snp.right)
        }
        
    }

    @IBAction func clickDelBtn(_ sender: Any) {
        delegate?.delDatabase(cell: self)
    }
}
