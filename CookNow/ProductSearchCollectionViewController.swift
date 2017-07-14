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
    private var filteredIngredients: [Ingredient] = []
    
    private let searchBar = UISearchBar()
    var searchButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.showsCancelButton = true
        
        searchButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Search"), style: .plain, target: self, action: #selector(searchButtonHandler(_:)))
        self.navigationItem.rightBarButtonItem = searchButton
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        DispatchQueue.global().async {
            self.ingredients = IngredientHanler.list()
            if let ingredients = self.ingredients {
                self.filteredIngredients = ingredients
            }
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.collectionView?.reloadData()
            }
        }
        
        self.collectionView!.register(UINib(nibName: "PantryCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredIngredients.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        if let cell = cell as? PantryCollectionViewCell {
            let ingredient = filteredIngredients[indexPath.row]
            cell.nameLabel.text = ingredient.name
            cell.amountLabel.text = ""
            
            DispatchQueue.global().async {
                if let image = ResourceHandler.loadImage(scope: .ingredient, id: Int(ingredient.id), handler: { return $0?.gradient(start: 0.25) }) {
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                }
            }
        }
    
        return cell
    }

    //MARK: - Search
    
    @IBAction func searchButtonHandler(_ sender: UIBarButtonItem) {
        showSearchBar()
    }
    
    func showSearchBar() {
        navigationItem.setRightBarButton(nil, animated: true)
        navigationItem.titleView = searchBar
        searchBar.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.searchBar.alpha = 1
        }, completion: { finished in
            self.searchBar.becomeFirstResponder()
        })
    }
    
    func hideSearchBar() {
        UIView.animate(withDuration: 0.3, animations: {
            self.searchBar.alpha = 0.0
        }, completion: { finished in
            self.navigationItem.titleView = nil
            self.navigationItem.setRightBarButton(self.searchButton, animated: true)
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            if let filtered =  self.ingredients?.filter({ $0.name.lowercased().hasPrefix(text.lowercased()) }) {
                self.filteredIngredients = filtered
                self.collectionView?.reloadData()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty){
            self.ingredients = nil
            self.collectionView?.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchBar()
    }

    // MARK: - CollectionView Deletage Methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize()
        }
        
        let viewWidth =  collectionView.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * CGFloat(columnCount - 1)
        let itemSize = viewWidth / CGFloat(columnCount)
        return CGSize(width: itemSize, height: itemSize)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ingredient = filteredIngredients[indexPath.row]
        let alert = UIAlertController(title: "Add Product", message: "Enter amount of \(ingredient.name)", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            let unitString = NSLocalizedString("Unit.\(ingredient.unit)", comment: "Unit")
            let placeholderText = NSLocalizedString("Alert.Ingredient.Add", comment: "Alert.Ingredient.Add")
            textField.placeholder = String(format: placeholderText, unitString)
        }
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Alert.Add", comment: "Alert.Add"), style: .default, handler: { [weak alert] (_) in
            if let textField = alert?.textFields![0] {
                if let amountText = textField.text {
                    if let amount = Double(amountText) {
                        self.save(ingredient: ingredient, withAmount: amount)
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Alert.Cancel", comment: "Alert.Cancel"), style: .destructive, handler: { (action) -> Void in }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Save
    
    func save(ingredient: Ingredient, withAmount amount: Double) {
        _ = PantryItem.add(ingredient: ingredient, withAmount: amount)
    }
}
