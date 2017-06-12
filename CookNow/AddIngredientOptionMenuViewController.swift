//
//  AddIngredientOptionMenuViewController.swift
//  CookNow
//
//  Created by Tobias on 12.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class AddIngredientOptionMenuViewController: UIViewController {

    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!
    
    weak var collectionViewController: PantryCollectionViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(recognizer:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleTapGesture(recognizer: UITapGestureRecognizer) {
        let point = recognizer.location(in: recognizer.view)
        if !buttonContainer.frame.contains(point) {
            self.dismiss(animated: true, completion: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


    @IBAction func searchHandler(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        collectionViewController?.performSegue(withIdentifier: "searchIngredientSegue", sender: collectionViewController)
    }
    
    @IBAction func scanHandler(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        collectionViewController?.performSegue(withIdentifier: "scanIngredientSegue", sender: collectionViewController)
    }
}
