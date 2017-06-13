
//
//  CookBookCollectionViewController.swift
//  CookNow
//
//  Created by Tobias on 13.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CookBookCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UINib(nibName: "CookBookCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: reuseIdentifier)

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
        // #warning Incomplete implementation, return the number of items
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        if let cell = cell as? CookBookCollectionViewCell {
            cell.titleLabel.text = "Nudelrezepte"
            DispatchQueue.global().async {
                if let image = ResourceHandler.loadImage(scope: .recipe, id: 1) {
                    DispatchQueue.main.sync {
                        cell.imageHeader.image = image
                    }
                }
                if let image = ResourceHandler.loadImage(scope: .recipe, id: 2) {
                    DispatchQueue.main.sync {
                        cell.imageFooter[0].image = image
                    }
                }
                
                if let image = ResourceHandler.loadImage(scope: .recipe, id: 3) {
                    DispatchQueue.main.sync {
                        cell.imageFooter[1].image = image
                    }
                }
                
                if let image = ResourceHandler.loadImage(scope: .recipe, id: 4) {
                    DispatchQueue.main.sync {
                        cell.imageFooter[2].image = image
                    }
                }
            }
        }
    
        return cell
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
