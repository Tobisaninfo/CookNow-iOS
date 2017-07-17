//
//  RecipeViewController.swift
//  CookNow
//
//  Created by Tobias on 20.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class RecipeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, RecipeAddViewControllerDelegate {

    private let imageCellIdentifier = "imageCell"
    private let infoCellIdentifier = "infoCell"
    private let ingredientCellIdentifier = "ingredientCell"
    private let startCellIdentifier = "startCell"
    
    var recipe: Recipe?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(UINib(nibName: "RecipeViewImageCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: imageCellIdentifier)
        self.collectionView!.register(UINib(nibName: "RecipeViewInfoCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: infoCellIdentifier)
        self.collectionView!.register(UINib(nibName: "RecipeViewIngredientCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: ingredientCellIdentifier)
        self.collectionView!.register(UINib(nibName: "RecipeViewStartButtonCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: startCellIdentifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(marketOfferDidUpdate(notification:)), name: MarketOffer.MarketOfferUpdate, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        self.collectionView?.reloadData()
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
                cell.nameLabel.text = recipe.name
                cell.imageView.image = image?.gradient()
                cell.setIngredientsAvailble(available: recipe.hasAllIngredients())
            }
            return cell
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: infoCellIdentifier, for: indexPath)
            if let recipe = recipe, let cell = cell as? RecipeViewInfoCollectionViewCell {
                let difficultyTest = NSLocalizedString("Difficulty.\(recipe.difficulty)", comment: "Difficulty")
                let text = "\(difficultyTest) • \(recipe.time) min • \(recipe.priceFormatted)"
                cell.infoLabel.text = text
                cell.parentViewController = self
            }
            return cell
        } else if let recipe = recipe, indexPath.row == 2 + recipe.ingredients.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: startCellIdentifier, for: indexPath)
            if let cell = cell as? RecipeViewStartButtonCollectionViewCell {
                cell.parentViewController = self
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ingredientCellIdentifier, for: indexPath)
            if let ingredient = recipe?.ingredients[indexPath.row - 2] {
                if let cell = cell as? RecipeViewIngredientCollectionViewCell {
                    let unitText = NSLocalizedString("Unit.\(ingredient.ingredient.unit)", comment: "Unit")
                    if ingredient.ingredient.unit != .Ohne  {
                        cell.amountLabel.text = "\(ingredient.amount.formatted) \(unitText)"
                    } else {
                        cell.amountLabel.text = ""
                    }
                    
                    cell.ingredientLabel.text = ingredient.ingredient.name
                    
                    cell.offerImageView.image = nil
                    DispatchQueue.global().async {
                        let hasOffer = ingredient.ingredient.hasOffer()
                        DispatchQueue.main.async {
                            cell.offerImageView.image = hasOffer ? #imageLiteral(resourceName: "Pricetag-Small") : nil
                        }
                    }
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
            return CGSize(width: viewWidth, height: 95)
        } else if let recipe = recipe, indexPath.row == 2 + recipe.ingredients.count {
            return CGSize(width: viewWidth, height: 48)
        } else {
            return CGSize(width: viewWidth, height: 17)
        }
    }
    
    // MARK: - Observer
    
    func marketOfferDidUpdate(notification: Notification) {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    // MARK: - Event Handler
    func addHandler(_ sender: UIButton) {
        let controller = RecipeAddViewController(title: NSLocalizedString("Alert.CookBook.Recipe.Add.Title", comment: "Title"), message: NSLocalizedString("Alert.CookBook.Recipe.Add.Description", comment: "Description"), preferredStyle: .alert)
        controller.setData(RecipeBook.list()!.map({return $0.name!}))
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    func shareHandler(_ sender: UIButton) {
        if let recipe = recipe, let image = image {
            let vc = UIActivityViewController(activityItems: [recipe.name, image], applicationActivities: [])
            present(vc, animated: true, completion: nil)
        }
    }
    
    // Delegate for adding to collection
    func didSelect(_ index: Int) {
        let recipeBook = RecipeBook.list()![index]
        if let recipe = recipe, let image = image {
            _ = RecipeRef.add(id: recipe.id, name: recipe.name, image: image, toBook: recipeBook)
        }
    }
}
