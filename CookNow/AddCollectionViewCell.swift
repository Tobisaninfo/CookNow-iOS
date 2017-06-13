//
//  PantryAddCollectionViewCell.swift
//  CookNow
//
//  Created by Tobias on 12.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class AddCollectionViewCell: UICollectionViewCell {
    
    var delegate: AddCollectionViewCellDelegate?
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func addHandler(_ sender: Any) {
        delegate?.onAction()
    }
}

protocol AddCollectionViewCellDelegate {
    func onAction()
}
