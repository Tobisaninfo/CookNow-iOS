//
//  RecipeViewImageCollectionViewCell.swift
//  CookNow
//
//  Created by Tobias on 20.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class RecipeViewImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var checkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setIngredientsAvailble(available: Bool) {
        if available {
            checkImageView.backgroundColor = UIColor.green
        } else {
            checkImageView.backgroundColor = UIColor.clear
        }
    }
    
    func setText(text: String, secondText: String? = nil) {
        if let secondText = secondText {
            nameLabel.text = text
            detailLabel.text = secondText
        } else {
            nameLabel.text = ""
            detailLabel.text = text
        }
    }
}
