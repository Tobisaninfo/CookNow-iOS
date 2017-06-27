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
    @IBOutlet weak var contentView: UITextView!
    
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
            imageView.image = ResourceHandler.getImage(scope: .recipe, id: recipeID)
            ingredientLabel.text = step.ingredients.map({return $0.ingredient.name}).reduce("", concatString)
            itemsLabel.text = step.items.map({return $0.name}).reduce("", concatString)
            contentView.text = step.content
        }
    }
    
    private func concatString(var1: String, var2: String) -> String {
        return var1 == "" ? var2 : var1 + ", " + var2
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
