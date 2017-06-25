
//
//  CookBookCollectionViewController.swift
//  CookNow
//
//  Created by Tobias on 13.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class CookBookCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, AddCollectionViewCellDelegate {

    private let reuseIdentifier0 = "Cell0"
    private let reuseIdentifier1 = "Cell1"
    private let reuseIdentifier2 = "Cell2"
    private let reuseIdentifier3 = "Cell3"
    private let reuseIdentifier4 = "Cell4"
    private let addReuseIdentifier = "AddCell"
    
    private let columnCount = 2
    
    private var items: [RecipeBook]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = self.editButtonItem

        // Register cell classes
        self.collectionView!.register(UINib(nibName: "CookBook0CollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: reuseIdentifier0)
        self.collectionView!.register(UINib(nibName: "CookBook1CollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: reuseIdentifier1)
        self.collectionView!.register(UINib(nibName: "CookBook2CollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: reuseIdentifier2)
        self.collectionView!.register(UINib(nibName: "CookBook3CollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: reuseIdentifier3)
        self.collectionView!.register(UINib(nibName: "CookBook4CollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: reuseIdentifier4)
        
        self.collectionView!.register(UINib(nibName: "AddCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: addReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        items = RecipeBook.list()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (items?.count ?? 0) + 1 // Add Cell
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.row == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: addReuseIdentifier, for: indexPath)
            if let cell = cell as? AddCollectionViewCell {
                cell.delegate = self
            }
            return cell
        } else {
            if let item = items?[indexPath.row - 1] {
                if let recipes = item.recipes {
                    var cell: UICollectionViewCell
                    if recipes.count == 1 {
                        cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier1, for: indexPath)
                    } else if recipes.count == 2 {
                        cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier2, for: indexPath)
                    } else if recipes.count == 3 {
                        cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier3, for: indexPath)
                    } else if recipes.count >= 4 {
                        cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier4, for: indexPath)
                    } else {
                        cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier0, for: indexPath)
                    }
                    
                    if let cell = cell as? CookBookCollectionViewCell {
                        cell.titleLabel.text = item.name
                        
                        if recipes.count > 0, let item = recipes.object(at: 0) as? RecipeRef {
                            if let data = item.image as Data? {
                                cell.imageHeader.image = UIImage(data: data)
                            }
                        }
                        if recipes.count > 1, let item = recipes.object(at: 1) as? RecipeRef {
                            if let data = item.image as Data? {
                                cell.imageFooter[0].image = UIImage(data: data)
                            }
                        }
                        if recipes.count > 2, let item = recipes.object(at: 2) as? RecipeRef {
                            if let data = item.image as Data? {
                                cell.imageFooter[1].image = UIImage(data: data)
                            }
                        }
                        if recipes.count > 3, let item = recipes.object(at: 3) as? RecipeRef {
                            if let data = item.image as Data? {
                                cell.imageFooter[2].image = UIImage(data: data)
                            }
                        }
                    }
                    return cell
                }
            }
            // Fallback, should never be called
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier0, for: indexPath)
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? PantryCollectionViewCell {
            cell.editing = isEditing
        }
    }

    // MARK: - Layout
    
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
                if let cell = self.collectionView?.cellForItem(at: indexPath) as? CookBookCollectionViewCell {
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
            
            self.items = RecipeBook.list()
            self.collectionView?.deleteItems(at: indexPaths)
        }
        self.setEditing(false, animated: true)
    }
    
    // MARK: - Navigation
    
    private var selectedCookBook: Int?
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
            if indexPath.row != 0 { // row == 0 --> add button
                selectedCookBook = indexPath.row - 1
                performSegue(withIdentifier: "recipeCollectionSegue", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? RecipeCollectionViewController {
            if let index = selectedCookBook {
                destinationViewController.recipeBook = items?[index]
            }
        }
    }
    
    // MARK: - Event Handler
    
    func onAction() {
        let alert = UIAlertController(title: NSLocalizedString("Alert.CookBook.Add.Title", comment: "Add CookBook"), message: NSLocalizedString("Alert.CookBook.Add.Description", comment: "Enter a name"), preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("Alert.CookBook.Add.Placeholder", comment: "Cook Book Name")
        }
        alert.addAction(UIAlertAction(title: NSLocalizedString("Alert.Cancel", comment: "Cancel"), style: .destructive, handler: { (action) -> Void in }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Alert.Add", comment: "Add"), style: .default, handler: { [weak alert] (_) in
            if let textField = alert?.textFields![0] {
                if let name = textField.text {
                    if let recipeBook = RecipeBook.add(name: name) {
                        self.items?.append(recipeBook)
                        self.collectionView?.reloadData()
                    }
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
