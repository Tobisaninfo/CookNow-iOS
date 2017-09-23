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
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView?.reloadData()
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
                cell.imageView.image = nil
                DispatchQueue.global().async {
                    if let data = recipe.image as Data?, let image = UIImage(data: data)?.gradient() {
                        DispatchQueue.main.async {
                            cell.animateImage(image: image)
                        }
                    }
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
    
    @objc func deleteHandler(_ sender: Any) {
        if let indexPaths = self.collectionView?.indexPathsForSelectedItems, let recipes = recipeBook?.recipes {
            var temp = [RecipeRef]()
            for indexPath in indexPaths {
                temp.append(recipes.object(at: indexPath.row) as! RecipeRef)
            }
            for recipe in temp {
                recipeBook?.removeFromRecipes(recipe)
                recipe.delete()
            }
            self.collectionView?.deleteItems(at: indexPaths)
        }
        self.setEditing(false, animated: true)

    }
    
    
    // MARK: - Navigation
    
    private var selectedIndex: IndexPath?
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
            selectedIndex = indexPath
            performSegue(withIdentifier: "recipeCollectionSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? RecipeViewController {
            if let index = selectedIndex?.row, let recipe = recipeBook?.recipes?.object(at: index) as? RecipeRef {
                if let data = recipe.image as Data? {
                    destinationViewController.image = UIImage(data: data)
                }
                destinationViewController.recipe = RecipeHandler.get(id: Int(recipe.id))
            }
        }
    }

}
