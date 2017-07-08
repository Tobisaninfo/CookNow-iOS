//
//  RecipeCollectionViewCell.swift
//  CookNow
//
//  Created by Tobias on 14.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var selectImageView: UIImageView!
        
    var editing: Bool = false {
        didSet {
            selectImageView.isHidden = !editing
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectImageView.image = #imageLiteral(resourceName: "Unchecked")
    }
    
    override var isSelected: Bool {
        didSet {
            if editing {
                if isSelected {
                    selectImageView.image = #imageLiteral(resourceName: "Checked")
                } else {
                    selectImageView.image = #imageLiteral(resourceName: "Unchecked")
                }
            }
        }
    }
    
    func animateImage(image: UIImage) {
        UIView.transition(with: imageView, duration: 1, options: .transitionCrossDissolve, animations: {
            self.imageView.image = image
        }, completion: nil)
    }
}
