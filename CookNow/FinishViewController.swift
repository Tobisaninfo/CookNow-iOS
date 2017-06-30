//
//  FinishViewController.swift
//  CookNow
//
//  Created by Tobias on 29.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class FinishViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var finishButton: UIButton!
        
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    @IBAction func finishButton(_ sender: UIButton) {
        if let recipe = recipe {
            // Remove Ingredients from Pantry
            recipe.done()
            
            // Remove from weekly plan
            if let planItem = PlanItem.find(recipe: recipe) {
                PlanGenerator.createNewItem(for: planItem, withNotificaiton: true)
            }
            self.parent?.navigationController?.popViewController(animated: true)
        }
    }
    
}
