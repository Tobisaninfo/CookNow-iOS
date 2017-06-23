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
    private let startCellIdentifier = "startCell"
    
    var recipe: Recipe? {
        didSet {
            if let collectionView = self.collectionView {
                DispatchQueue.main.sync {
                    collectionView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
            self.recipe = RecipeHandler.get(id: 1)
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UINib(nibName: "RecipeViewImageCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: imageCellIdentifier)
        self.collectionView!.register(UINib(nibName: "RecipeViewInfoCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: infoCellIdentifier)
        self.collectionView!.register(UINib(nibName: "RecipeViewIngredientCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: ingredientCellIdentifier)
        self.collectionView!.register(UINib(nibName: "RecipeViewStartButtonCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: startCellIdentifier)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeStepSegue" {
            if let destinationViewController = segue.destination as? RecipeStepViewController {
                destinationViewController.recipe = recipe
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let ingredientCount = recipe?.ingredients.count {
            return 3 + ingredientCount
        } else {
            return 3
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellIdentifier, for: indexPath)
            if let recipe = recipe, let cell = cell as? RecipeViewImageCollectionViewCell {
                cell.setText(text: recipe.name)
                DispatchQueue.global().async {
                    if let image = ResourceHandler.loadImage(scope: .recipe, id: recipe.id) {
                        DispatchQueue.main.sync {
                            cell.imageView.image = image.gradient()
                        }
                    }
                }
            }
            return cell
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: infoCellIdentifier, for: indexPath)
            if let recipe = recipe, let cell = cell as? RecipeViewInfoCollectionViewCell {
                let difficultyTest = NSLocalizedString("Difficulty.\(recipe.difficulty)", comment: "Difficulty")
                let text = "\(difficultyTest) • \(recipe.time) min • \(recipe.priceFormatted)"
                cell.infoLabel.text = text
            }
            return cell
        } else if let recipe = recipe, indexPath.row == 2 + recipe.ingredients.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: startCellIdentifier, for: indexPath)
            if let cell = cell as? RecipeViewStartButtonCollectionViewCell {
                cell.rootViewController = self
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ingredientCellIdentifier, for: indexPath)
            if let ingredient = recipe?.ingredients[indexPath.row - 2] {
                if let cell = cell as? RecipeViewIngredientCollectionViewCell {
                    let unitText = NSLocalizedString("Unit.\(ingredient.ingredient.unit)", comment: "Unit")
                    cell.amountLabel.text = "\(ingredient.amountFormatted) \(unitText)"
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
            return CGSize(width: viewWidth, height: 250)
        } else if indexPath.row == 1 {
            return CGSize(width: viewWidth, height: 55)
        } else if let recipe = recipe, indexPath.row == 2 + recipe.ingredients.count {
            return CGSize(width: viewWidth, height: 30)
        } else {
            return CGSize(width: viewWidth, height: 21)
        }
    }
}
