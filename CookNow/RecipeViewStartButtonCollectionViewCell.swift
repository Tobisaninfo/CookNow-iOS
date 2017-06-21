//
//  RecipeViewStartButtonCollectionViewCell.swift
//  CookNow
//
//  Created by Tobias on 21.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class RecipeViewStartButtonCollectionViewCell: UICollectionViewCell {

    weak var rootViewController: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func startHander(_ sender: UIButton) {
        rootViewController?.performSegue(withIdentifier: "recipeStepSegue", sender: self)
    }

}
