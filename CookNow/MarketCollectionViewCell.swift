//
//  MarketCollectionViewCell.swift
//  CookNow
//
//  Created by Tobias on 25.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class MarketCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.layer.borderColor = UIColor.red.cgColor
                self.layer.borderWidth = 2
            } else {
                self.layer.borderColor = UIColor.clear.cgColor
                self.layer.borderWidth = 2
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
