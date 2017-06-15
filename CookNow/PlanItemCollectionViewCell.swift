//
//  PlanItemCollectionViewCell.swift
//  CookNow
//
//  Created by Tobias on 15.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class PlanItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var flopImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.global().async {
            if let image = ResourceHandler.loadImage(scope: .recipe, id: 1) {
                DispatchQueue.main.sync {
                    self.recipeImage.image = image
                }
            }
        }
    }

}
