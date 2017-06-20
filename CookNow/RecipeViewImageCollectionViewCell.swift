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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.global().async {
            if let image = ResourceHandler.loadImage(scope: .recipe, id: 1) {
                DispatchQueue.main.sync {
                    self.imageView.image = image
                }
            }
        }
    }
}
