//
//  RecipeViewController.swift
//  CookNow
//
//  Created by Tobias on 20.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class RecipeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let imageCellIdentifier = "imageCell"
    private let infoCellIdentifier = "infoCell"
    private let ingredientCellIdentifier = "ingredientCell"
    
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UINib(nibName: "RecipeViewImageCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: imageCellIdentifier)
        self.collectionView!.register(UINib(nibName: "RecipeViewInfoCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: infoCellIdentifier)
        self.collectionView!.register(UINib(nibName: "RecipeViewIngredientCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: ingredientCellIdentifier)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let ingredientCount = recipe?.ingredients.count {
            return 2 + ingredientCount
        } else {
            return 2
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellIdentifier, for: indexPath)
            return cell
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: infoCellIdentifier, for: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ingredientCellIdentifier, for: indexPath)
            if let ingredient = recipe?.ingredients[indexPath.row - 2] {
                if let cell = cell as? RecipeViewIngredientCollectionViewCell {
                    cell.amountLabel.text = "\(ingredient.amount) \(ingredient.ingredient.unit)"
                    cell.ingredientLabel.text = ingredient.ingredient.name
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize()
        }
        
        let viewWidth =  collectionView.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
        if indexPath.row == 0 {
            return CGSize(width: viewWidth, height: 200)
        } else if indexPath.row == 1 {
            return CGSize(width: viewWidth, height: 60)
        } else if indexPath.row == 2 {
            return CGSize(width: viewWidth, height: 21)
        }
        return CGSize.zero
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
