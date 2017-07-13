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
    
    @IBOutlet weak var checkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setIngredientsAvailble(available: Bool) {
        if available {
            checkImageView.image = #imageLiteral(resourceName: "Checked")
        } else {
            checkImageView.image = nil
        }
    }
}
