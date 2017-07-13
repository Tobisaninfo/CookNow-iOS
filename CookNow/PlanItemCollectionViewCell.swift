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
    
    var topRating: Rating?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setImageForTopButton(image: UIImage) {
        topButton.setImage(image, for: .normal)
    }

    @IBAction func topHandler(_ sender: UIButton) {
        if let rating = topRating {
            rating.delete()
            setImageForTopButton(image: #imageLiteral(resourceName: "Thumbsup"))
            topRating = nil
        } else {
            if let planItem = planItem {
                topRating = Rating.top(recipe: planItem)
                setImageForTopButton(image: #imageLiteral(resourceName: "Thumbsup-Filled"))
            }
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
