//
//  StepViewController.swift
//  CookNow
//
//  Created by Tobias on 21.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class StepViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var itemsLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var recipeID: Int?
    var step: Step? {
        didSet {
            setContent()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setContent() {
        if isViewLoaded, let step = step, let recipeID = recipeID {
            DispatchQueue.global().async {
                if let image = ResourceHandler.loadImage(scope: .recipe, id: recipeID) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
            ingredientLabel.text = step.ingredients.map({return $0.ingredient.name}).reduce("", concatString)
            itemsLabel.text = step.items.map({return $0.name}).reduce("", concatString)
            contentLabel.text = step.content
        }
    }
    
    private func concatString(var1: String, var2: String) -> String {
        return var1 == "" ? var2 : var1 + ", " + var2
    }

}
