//
//  SearchCollectionViewCell.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 23/05/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import UIKit

protocol CellDelegate: class {
    func addDatabase(cell: SearchCollectionViewCell)
}

class SearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bjNameLabel: UILabel!
    @IBOutlet weak var bjProfileImageView: UIImageView!
    @IBOutlet weak var broadcastMent: UILabel!
    @IBOutlet weak var broadcastName: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    
    weak var delegate: CellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitialize()
    }
    
    func setupInitialize() {
        broadcastMent.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func addBtn(_ sender: Any) {
        delegate?.addDatabase(cell: self)
    }
    
}
     
