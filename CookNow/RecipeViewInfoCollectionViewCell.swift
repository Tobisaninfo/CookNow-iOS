//
//  RecipeViewInfoCollectionViewCell.swift
//  CookNow
//
//  Created by Tobias on 20.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class RecipeViewInfoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    weak var parentViewController: RecipeViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func addHandler(_ sender: UIButton) {
        parentViewController?.addHandler(sender)
    }
    
    @IBAction func shareHandler(_ sender: UIButton) {
        parentViewController?.shareHandler(sender)
    }
}
