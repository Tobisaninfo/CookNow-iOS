//
//  PlanCollectionViewCell.swift
//  CookNow
//
//  Created by Tobias on 15.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class PlanCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let cellReuseIdentifier = "Cell"
    
    private var planItems: [PlanItem]?
    
    weak var homeViewController: HomeCollectionViewController?
    
    @IBOutlet weak var planCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.planCollectionView.register(UINib(nibName: "PlanItemCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: cellReuseIdentifier)

        self.planItems = PlanItem.getCurrentPlan()?.sorted(by: {$0.order < $1.order})
        
        planCollectionView.delegate = self
        planCollectionView.dataSource = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return planItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = planCollectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        if let cell = cell as? PlanItemCollectionViewCell, let item = planItems?[indexPath.row] {
            DispatchQueue.global().async {
                let image = ResourceHandler.loadImage(scope: .recipe, id: Int(item.recipeID))
                let recipe = RecipeHandler.get(id: Int(item.recipeID))
                
                DispatchQueue.main.sync {
                    cell.nameLabel.text = recipe?.name
                    cell.recipeImage.image = image
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125, height: 125)
    }
    
    // MARK: - Navigation
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = planItems?[indexPath.row].recipeID {
            homeViewController?.selectedRecipe = Int(id)
            homeViewController?.performSegue(withIdentifier: "planRecipeSegue", sender: homeViewController)
        }
    }

}
