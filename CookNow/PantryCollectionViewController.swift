//
//  PantryCollectionViewController.swift
//  CookNow
//
//  Created by Tobias on 10.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class PantryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, AddCollectionViewCellDelegate {
    
    private let pantryReuseIdentifier = "pantryCell"
    private let addReuseIdentifier = "pantryAddCell"
    private let columnCount = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UINib(nibName: "PantryCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: pantryReuseIdentifier)
        self.collectionView!.register(UINib(nibName: "AddCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: addReuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddIngredientOptionMenuViewController {
            vc.collectionViewController = self
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 30
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.row == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: addReuseIdentifier, for: indexPath) as! AddCollectionViewCell
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pantryReuseIdentifier, for: indexPath) as! PantryCollectionViewCell
            
            DispatchQueue.global().async {
                if let image = ResourceHandler.loadImage(scope: .ingredient, id: 1) {
                    DispatchQueue.main.sync {
                        cell.animate(image: image)
                    }
                }
            }
            
            cell.nameLabel.text = "Apfel"
            cell.amountLabel.text = "3 Stück"
            // Configure the cell
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize()
        }
        
        let viewWidth =  collectionView.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * CGFloat(columnCount - 1)
        let itemSize = viewWidth / CGFloat(columnCount)
        return CGSize(width: itemSize, height: itemSize)
    }
    
    func onAction() {
        performSegue(withIdentifier: "addIngredient", sender: self)
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
