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
        
        items = loadPantryItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView?.reloadData()
    }
    
    
    func loadPantryItems() -> [PantryItem]? {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            do {
                return try delegate.persistentContainer.viewContext.fetch(NSFetchRequest(entityName: "PantryItem")) as? [PantryItem]
            } catch {
                print(error)
            }
        }
        return nil
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddIngredientOptionMenuViewController {
            vc.collectionViewController = self
        }
        
        if let vc = segue.destination as? ProductSearchCollectionViewController {
            vc.pantryViewController = self
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
                if let ingredient = IngredientHanler.get(id: Int(item.ingredientID)) {
                    loadImage(forIndex: indexPath)
                    
                    if let item = ResourceHandler.getImage(scope: .ingredient, id: ingredient.id) {
                        cell.animate(image: item)
                    }
                    let unitText = NSLocalizedString("Unit.\(ingredient.unit)", comment: "Unit")
                    cell.nameLabel.text = ingredient.name
                    cell.amountLabel.text = "\(item.amount) \(unitText)"
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
            loadImage(forIndex: indexPath)
        }
    }
    
    private var tasks: [IndexPath] = []
    
    func loadImage(forIndex indexPath: IndexPath) {
        if !tasks.contains(indexPath) {
            if let index = items?[indexPath.row - 1] {
                tasks.append(indexPath)
                print("Prefetch \(indexPath)")
                DispatchQueue.global().async {
                    _ = ResourceHandler.loadImage(scope: .ingredient, id: Int(index.ingredientID))
                    DispatchQueue.main.async {
                        self.collectionView?.reloadItems(at: [indexPath])
                        self.tasks.remove(at: self.tasks.index(of: indexPath)!)
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
