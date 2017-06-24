//
//  PantryCollectionViewController.swift
//  CookNow
//
//  Created by Tobias on 10.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit
import CoreData

class PantryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching, AddCollectionViewCellDelegate {
    
    private let pantryReuseIdentifier = "pantryCell"
    private let addReuseIdentifier = "pantryAddCell"
    private let columnCount = 3
    
    var items: [PantryItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UINib(nibName: "PantryCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: pantryReuseIdentifier)
        self.collectionView!.register(UINib(nibName: "AddCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: addReuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.items = PantryItem.list()
        self.collectionView?.reloadData()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddIngredientOptionMenuViewController {
            vc.collectionViewController = self
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (items?.count ?? 0) + 1 // add Cell
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.row == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: addReuseIdentifier, for: indexPath) as! AddCollectionViewCell
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pantryReuseIdentifier, for: indexPath) as! PantryCollectionViewCell
            
            if let item = items?[indexPath.row - 1] {
                if let item = ResourceHandler.getImage(scope: .ingredient, id: Int(item.ingredientID)) {
                    cell.imageView.image = item.gradient()
                } else {
                    self.loadData(forIndex: indexPath)
                }
                
                if let ingredient = IngredientHanler.getLocal(id: Int(item.ingredientID)) {
                    let unitText = NSLocalizedString("Unit.\(ingredient.unit)", comment: "Unit")
                    cell.nameLabel.text = ingredient.name
                    cell.amountLabel.text = "\(item.amount) \(unitText)"
                } else {
                    self.loadData(forIndex: indexPath)
                }
            }
            
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
    
    // MARK: - CollectionView Prefetch Data
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if indexPath.row != 0 {
                loadData(forIndex: indexPath)
            }
        }
    }
    
    private var tasks: [Int] = []
    
    func loadData(forIndex indexPath: IndexPath) {
        if !tasks.contains(indexPath.row) {
            if let item = items?[indexPath.row - 1] {
                tasks.append(indexPath.row)
                DispatchQueue.global().async {
                    _ = ResourceHandler.loadImage(scope: .ingredient, id: Int(item.ingredientID))
                    _ = IngredientHanler.get(id: Int(item.ingredientID))
                    DispatchQueue.main.async {
                        self.collectionView?.reloadItems(at: [indexPath])
                    }
                }
            }
        }
    }
    
    // MARK: - Utils
    
    func onAction() {
        performSegue(withIdentifier: "addIngredient", sender: self)
    }
}
