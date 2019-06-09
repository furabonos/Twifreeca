//
//  AfreecaCollectionViewCell.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 04/06/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import UIKit
import SnapKit
import MarqueeLabel

protocol DeleteBjDelegate: class {
    func delDatabase(cell: AfreecaCollectionViewCell)
}

class AfreecaCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bjLabel: UILabel!
    @IBOutlet weak var bjImageView: UIImageView!
    @IBOutlet weak var onOffLabel: UILabel!
    @IBOutlet weak var broadcastLabel: UILabel!
    @IBOutlet weak var delBtn: UIButton!
    
    weak var delegate: DeleteBjDelegate?
    
    lazy var mrLabel: MarqueeLabel = {
        var label = MarqueeLabel()
        label.text = ""
        label.marqueeType = .MLContinuous
        label.fadeLength = 10.0
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitialize()
    }
    
    func setupInitialize() {
        broadcastLabel.adjustsFontSizeToFitWidth = true
//        mrLabel.isHidden = true
        self.contentView.addSubview(mrLabel)
        mrLabel.snp.makeConstraints { (m) in
            m.width.equalTo(broadcastLabel.snp.width)
            m.height.equalTo(broadcastLabel.snp.height)
            m.top.equalTo(broadcastLabel.snp.top)
            m.left.equalTo(broadcastLabel.snp.left)
        }
    }
    
    @IBAction func delBJ(_ sender: Any) {
        delegate?.delDatabase(cell: self)
    }
    
}
