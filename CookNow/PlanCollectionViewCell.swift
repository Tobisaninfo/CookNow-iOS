//
//  PlanCollectionViewCell.swift
//  CookNow
//
//  Created by Tobias on 15.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class PlanCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {

    private let cellReuseIdentifier = "Cell"
    
    private var planItems: [PlanItem]?
    private var images: [Int: UIImage] = [:] // IndexPath.Row : Image
    private var recipes: [Int: Recipe] = [:] //IndexPath.Row : Recipe
    
    weak var homeViewController: HomeCollectionViewController?
    
    @IBOutlet weak var planCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.planCollectionView.register(UINib(nibName: "PlanItemCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: cellReuseIdentifier)

        self.planItems = PlanItem.getCurrentPlan()?.sorted(by: {$0.order < $1.order})
        
        planCollectionView.delegate = self
        planCollectionView.dataSource = self
        planCollectionView.prefetchDataSource = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return planItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = planCollectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        if let cell = cell as? PlanItemCollectionViewCell {
            if let recipe = recipes[indexPath.row] {
                cell.nameLabel.text = recipe.name
            } else {
                self.loadData(forIndex: indexPath)
            }
            if let image = images[indexPath.row] {
                cell.recipeImage.image = image
            } else {
                self.loadData(forIndex: indexPath)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125, height: 125)
    }
    
    // MARK: - Navigation
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        homeViewController?.selectedRecipe = recipes[indexPath.row]
        homeViewController?.performSegue(withIdentifier: "planRecipeSegue", sender: homeViewController)
    }

    // MARK: - Prefetching
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            loadData(forIndex: indexPath)
        }
    }
    
    private var tasks: [Int] = []
    
    private func loadData(forIndex indexPath: IndexPath) {
        if !tasks.contains(indexPath.row) {
            if let item = planItems?[indexPath.row] {
                tasks.append(indexPath.row)
                DispatchQueue.global().async {
                    self.images[indexPath.row] = ResourceHandler.loadImage(scope: .recipe, id: Int(item.recipeID))
                    self.recipes[indexPath.row] = RecipeHandler.get(id: Int(item.recipeID))
                    
                    DispatchQueue.main.sync {
                        self.planCollectionView?.reloadItems(at: [indexPath])
                    }
                }
            }
        }
    }

}
