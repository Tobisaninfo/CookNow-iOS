//
//  PantryAddCollectionViewCell.swift
//  CookNow
//
//  Created by Tobias on 12.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class PantryAddCollectionViewCell: UICollectionViewCell {

    weak var collectionViewController: PantryCollectionViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func addHandler(_ sender: Any) {
        collectionViewController?.performSegue(withIdentifier: "addIngredient", sender: collectionViewController)
    }
}
