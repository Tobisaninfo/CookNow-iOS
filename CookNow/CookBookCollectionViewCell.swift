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
        
        selectImageView.backgroundColor = UIColor.green
    }
    
    override var isSelected: Bool {
        didSet {
            if editing {
                if isSelected {
                    selectImageView.image = nil
                    selectImageView.backgroundColor = UIColor.red
                } else {
                    selectImageView.image = nil
                    selectImageView.backgroundColor = UIColor.green
                }
            }
        }
    }

}
