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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self, selector: #selector(replceItemByObserver(notification:)), name: PlanGenerator.NewPlanItem, object: nil)
        
        self.planCollectionView.register(UINib(nibName: "PlanItemCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: cellReuseIdentifier)

        loadData()
        
        planCollectionView.delegate = self
        planCollectionView.dataSource = self
    }

    private func loadData() {
        self.planItems = PlanItem.getCurrentPlan()?.sorted(by: {$0.order < $1.order})
    }
    
    // MARK: -CollectionView Deletage
    
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
                    
                    cell.planItem = item
                    cell.planCollectionViewCell = self
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125, height: 125)
    }
    
    func replceItemByObserver(notification: Notification) {
        if let index = notification.object as? Int {
            replaceItem(index: index)
        }
    }
    
    func replaceItem(index: Int) {
        loadData()
        let viewIndex = index - 1
        if viewIndex < 7 && viewIndex >= 0 {
            planCollectionView.reloadItems(at: [IndexPath(row: viewIndex, section: 0)])
        } else {
            planCollectionView.reloadData()
        }
    }
    
    // MARK: - Navigation
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = planItems?[indexPath.row].recipeID {
            homeViewController?.selectedRecipe = Int(id)
            homeViewController?.performSegue(withIdentifier: "planRecipeSegue", sender: homeViewController)
        }
    }

}
