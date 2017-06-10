//
//  PnatryCollectionViewCell.swift
//  CookNow
//
//  Created by Tobias on 10.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class PantryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func animate(image: UIImage) {
        UIView.transition(with: self.imageView, duration:1, options: .transitionCrossDissolve, animations: {
            self.imageView.image = image
        }, completion: nil)
    }
    
}
