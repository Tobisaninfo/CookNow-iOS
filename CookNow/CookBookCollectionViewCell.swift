//
//  CookBookCollectionViewCell.swift
//  CookNow
//
//  Created by Tobias on 13.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class CookBookCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageHeader: UIImageView!
    @IBOutlet var imageFooter: [UIImageView]!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
