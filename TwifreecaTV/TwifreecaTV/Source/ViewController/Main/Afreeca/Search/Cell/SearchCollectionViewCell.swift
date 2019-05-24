//
//  SearchCollectionViewCell.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 23/05/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bjNameLabel: UILabel!
    @IBOutlet weak var bjProfileImageView: UIImageView!
    @IBOutlet weak var broadcastMent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitialize()
    }
    
    func setupInitialize() {
        broadcastMent.adjustsFontSizeToFitWidth = true
    }

}
     
