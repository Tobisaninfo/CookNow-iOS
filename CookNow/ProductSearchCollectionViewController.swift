//
//  ProductSearchCollectionViewController.swift
//  CookNow
//
//  Created by Tobias on 13.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit
import CoreData

class ProductSearchCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    private let reuseIdentifier = "Cell"
    private let columnCount = 3

    private var ingredients: [Ingredient]?
    var pantryViewController: PantryCollectionViewController?
    
    private var activityIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UINib(nibName: "PantryCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredients?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        if let cell = cell as? PantryCollectionViewCell {
            if let ingredient = ingredients?[indexPath.row] {
                cell.nameLabel.text = ingredient.name
                
                DispatchQueue.global().async {
                    if let image = ResourceHandler.loadImage(scope: .ingredient, id: 1) {
                        DispatchQueue.main.sync {
                            cell.animate(image: image)
                        }
                    }
                }
            }
        }
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionElementKindSectionHeader) {
            let headerView:UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SearchBarHeader", for: indexPath)
            
            return headerView
        }
        
        return UICollectionReusableView()
        
    }
    
    //MARK: - Search
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            DispatchQueue.global().async {
                self.ingredients = IngredientHanler.list()
                self.ingredients = IngredientHanler.list().filter() {
                    $0.name.hasPrefix(text)
                }
                DispatchQueue.main.sync {
                    self.collectionView?.reloadData()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty){
            self.ingredients = nil
            self.collectionView?.reloadData()
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let ingredient = ingredients?[indexPath.row] {
            let alert = UIAlertController(title: "Add Product", message: "Enter amount of \(ingredient.name)", preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.placeholder = "350 \(ingredient.unit)"
            }
            
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
                if let textField = alert?.textFields![0] {
                    if let amountText = textField.text {
                        if let amount = Double(amountText) {
                            self.save(ingredient: ingredient, withAmount: amount)
                        }
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Save
    func save(ingredient: Ingredient, withAmount amount: Double) {
        if let item = PantryItem.add(id: ingredient.id, withAmount: amount) {
            pantryViewController?.items?.append(item)
        }
    }

}
