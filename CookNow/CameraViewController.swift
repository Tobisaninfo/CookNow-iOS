//
//  CameraViewController.swift
//  CookNow
//
//  Created by Tobias on 01.07.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: BarcodeController, BarcodeControllerDelegate, CameraItemViewDataSource, CameraItemViewDelegate {
    
    let itemView = CameraItemView()
    
    @IBOutlet weak var flashButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        allowMultipleMetadataObjects = false
        
        itemView.delegate = self
        itemView.dataSource = self
        
        view.bringSubview(toFront: flashButton)
    }
    
    @IBAction func flashButtonHandler(_ sender: UIButton) {
        self.isTourchEnable = !self.isTourchEnable
        flashButton.setImage(isTourchEnable ? #imageLiteral(resourceName: "Flash-Filled") : #imageLiteral(resourceName: "Flash"), for: .normal)
    }
    
    private var recipe: Recipe?
    private var ingredientName: String?
    private var recipeName: String?
    private var recipeImage: UIImage?
    private var currentCode: String?
    
    func barcodeDidDetect(code: String, frame: CGRect) {
        if let currentCode = currentCode, currentCode != code {
            self.finishReding(code: currentCode)
        }
        self.itemView.removeFromSuperview()
        
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        
        self.currentCode = code
        
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
                    if recipes.count > 0 {
                        self.recipe = recipes[Int(arc4random_uniform(UInt32(recipes.count)))]
                        if let recipe = self.recipe {
                            self.recipeName = recipe.name
                            self.recipeImage = ResourceHandler.loadImage(scope: .recipe, id: recipe.id)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.itemView.reloadData()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.ingredientName = barcode.name
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
        if let currentCode = currentCode {
            self.finishReding(code: currentCode)
            self.itemView.removeFromSuperview()
            
            if recipe != nil {
                self.performSegue(withIdentifier: "RecipeViewSegue", sender: self)
            }
        }
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
