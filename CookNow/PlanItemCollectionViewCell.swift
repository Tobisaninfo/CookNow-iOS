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
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var flopButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    var planCollectionViewCell: PlanCollectionViewCell?
    var planItem: PlanItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func topHandler(_ sender: UIButton) {
        if let planItem = planItem {
            Rating.top(recipe: planItem)
        }
    }
    
    @IBAction func flopHandler(_ sender: UIButton) {
        if let planItem = planItem {
            let index = Int(planItem.day)
            
            Rating.flop(recipe: planItem)
            PlanGenerator.createNewItem(for: planItem)
            planCollectionViewCell?.replaceItem(index: index)
        }
    }
}
