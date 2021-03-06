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
    @IBOutlet weak var selectImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
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
    
    func animateImage(image: UIImage, forIndex index: Int) {
        let imageView: UIImageView!
        if index == 0 {
            imageView = imageHeader
        } else {
            imageView = imageFooter[index - 1]
        }
        UIView.transition(with: imageView, duration:1, options: .transitionCrossDissolve, animations: {
            imageView.image = image
        }, completion: nil)
    }
}
