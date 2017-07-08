//
//  CameraViewController.swift
//  CookNow
//
//  Created by Tobias on 01.07.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class CameraViewController: BarcodeController, BarcodeControllerDelegate, CameraItemViewDataSource, CameraItemViewDelegate {
    
    let itemView = CameraItemView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        allowMultipleMetadataObjects = true
        
        itemView.delegate = self
        itemView.dataSource = self
    }
    
    private var recipe: Recipe?
    private var ingredientName: String?
    private var recipeName: String?
    private var recipeImage: UIImage?
    
    func barcodeDidDetect(code: String, frame: CGRect) {
        var origin = frame.origin
        
        if origin.x + 260 > self.view.bounds.size.width {
            origin.x = self.view.bounds.size.width / 2 - 130
        }
        
        if origin.y + 130 > self.view.bounds.size.height {
            origin.y = self.view.bounds.size.height / 2 - 70
        }
        
        itemView.frame = CGRect(origin: origin, size: CGSize(width: 260, height: 130))
        
        itemView.reloadData()
        
        DispatchQueue.global().async {
            if let barcode = IngredientHanler.barcode(code: code) {
                if let ingredient = barcode.ingredient {
                    self.ingredientName = ingredient.name
                    
                    let recipes = RecipeHandler.list(ingredientID: ingredient.id)
                    self.recipe = recipes[Int(arc4random_uniform(UInt32(recipes.count)))]
                    
                    if let recipe = self.recipe {
                        self.recipeName = recipe.name
                        self.recipeImage = ResourceHandler.loadImage(scope: .recipe, id: recipe.id)
                    }
                    
                    DispatchQueue.main.async {
                        self.itemView.reloadData()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.ingredientName = "Failed"
                        self.itemView.reloadData()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.ingredientName = "Failed"
                    self.itemView.reloadData()
                }
            }
        }

        
        self.view.addSubview(itemView)
        self.view.bringSubview(toFront: itemView)
    }
    
    func shouldShowActivityView() -> Bool {
        return ingredientName == nil
    }
    
    func didSelectReicpeImage() {
        self.performSegue(withIdentifier: "RecipeViewSegue", sender: self)
    }
    
    func ingredientNameForItem() -> String? {
        return ingredientName
    }
    
    func recipeNameForItem() -> String? {
        return recipeName
    }
    
    func recipeImageForItem() -> UIImage? {
        return recipeImage
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController =  segue.destination as? RecipeViewController {
            destinationViewController.recipe = recipe
            destinationViewController.image = recipeImage
        }
    }
}
