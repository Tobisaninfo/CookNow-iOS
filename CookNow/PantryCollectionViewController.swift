//
//  PantryCollectionViewController.swift
//  CookNow
//
//  Created by Tobias on 10.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit
import CoreData

class PantryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, AddCollectionViewCellDelegate {
    
    private let pantryReuseIdentifier = "pantryCell"
    private let addReuseIdentifier = "pantryAddCell"
    private let columnCount = 3
    
    var items: [PantryItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
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
            
            if let item = items?[indexPath.row - 1], let unit = Unit(rawValue: Int(item.unit)) {
                let unitText = NSLocalizedString("Unit.\(unit)", comment: "Unit")
                cell.nameLabel.text = item.name
                cell.amountLabel.text = "\(item.amountFormatted) \(unitText)"
                
                cell.imageView.image = nil
                DispatchQueue.global().async {
                    let image = ResourceHandler.loadImage(scope: .ingredient, id: Int(item.ingredientID)) {
                        return $0?.gradient(start: 0.25)
                    }
                    DispatchQueue.main.async {
                        if let image = image {
                            cell.imageView.image = image
                        }
                    }
                }
            }
            
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? PantryCollectionViewCell {
            cell.editing = isEditing
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

    // MARK: - Edit

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        self.collectionView?.allowsMultipleSelection = editing
        if let indexPaths = self.collectionView?.indexPathsForVisibleItems {
            for indexPath in indexPaths {
                self.collectionView?.deselectItem(at: indexPath, animated: false)
                if let cell = self.collectionView?.cellForItem(at: indexPath) as? PantryCollectionViewCell {
                    cell.editing = editing
                }
            }
        }
        
        if editing {
            self.navigationController?.isToolbarHidden = false
            var items = [UIBarButtonItem]()
            items.append(UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteHandler(_:))))
            self.navigationController?.toolbar.items = items
        } else {
            self.navigationController?.isToolbarHidden = true
        }
    }
    
    func deleteHandler(_ sender: Any) {
        if let indexPaths = self.collectionView?.indexPathsForSelectedItems, let items = self.items {
            for indexPath in indexPaths {
                items[indexPath.row - 1].delete()
            }
            
            self.items = PantryItem.list()
            self.collectionView?.deleteItems(at: indexPaths)
        }
        self.setEditing(false, animated: true)
    }
    
    // MARK: - Utils
    
    func onAction() {
        performSegue(withIdentifier: "addIngredient", sender: self)
    }
}
