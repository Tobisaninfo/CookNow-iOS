//
//  RecipeCollectionViewController.swift
//  CookNow
//
//  Created by Tobias on 14.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit
import TBEmptyDataSet

class RecipeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, TBEmptyDataSetDelegate, TBEmptyDataSetDataSource {

    private let reuseIdentifier = "Cell"
    private let columnCount = 2
    
    var recipeBook: RecipeBook?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup Placeholder
        self.collectionView?.emptyDataSetDelegate = self
        self.collectionView?.emptyDataSetDataSource = self
        
        self.title = recipeBook?.name
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Register cell classes
        self.collectionView!.register(UINib(nibName: "RecipeCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeBook?.recipes?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        if let cell = cell as? RecipeCollectionViewCell {
            if let recipe = recipeBook?.recipes?.object(at: indexPath.row) as? RecipeRef {
                cell.nameLabel.text = recipe.name
                if let data = recipe.image as Data? {
                    cell.imageView.image = UIImage(data: data)
                }
            }
        }
    
        return cell
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
    
    
    // MARK: - Placeholder

    func titleForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "No Recipes")
    }
    
    // MARK: - Edit
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        self.collectionView?.allowsMultipleSelection = editing
        if let indexPaths = self.collectionView?.indexPathsForVisibleItems {
            for indexPath in indexPaths {
                self.collectionView?.deselectItem(at: indexPath, animated: false)
                if let cell = self.collectionView?.cellForItem(at: indexPath) as? RecipeCollectionViewCell {
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
        
    }
    
    
    // MARK: - Navigation
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "recipeCollectionSegue", sender: self)
    }

}
