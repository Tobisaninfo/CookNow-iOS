//
//  HomeCollectionViewController.swift
//  CookNow
//
//  Created by Tobias on 15.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit


class HomeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let planReuseIdentifier = "PlanCell"
    private let itemReuseIdentifier = "ItemCell"

    private let columnCount = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UINib(nibName: "PlanCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: planReuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation
    
    var selectedRecipe: Int?

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewControler = segue.destination as? RecipeViewController, let id = selectedRecipe {
            destinationViewControler.recipe = RecipeHandler.get(id: id)
            destinationViewControler.image = ResourceHandler.loadImage(scope: .recipe, id: id)
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: planReuseIdentifier, for: indexPath)
            
            if let cell = cell as? PlanCollectionViewCell {
                cell.homeViewController = self
            }
            
            return cell
        } else {
            // TODO
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemReuseIdentifier, for: indexPath)
        
            // Configure the cell
        
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionElementKindSectionHeader) {
            let headerView:UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "TitleHeander", for: indexPath)
            if let headerView = headerView as? TitleCollectionReusableView {
                if indexPath.section == 0 {
                    headerView.titleLabel.text = "Weekly Plan"
                } else if indexPath.section == 1 {
                    headerView.titleLabel.text = "Tipps"
                }
            }
            return headerView
        }
        
        return UICollectionReusableView()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize()
        }
        
        if indexPath.section == 0 {
            let viewWidth =  collectionView.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
            return CGSize(width: viewWidth, height: 125)
        } else if indexPath.section == 1 {
            let viewWidth =  collectionView.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * CGFloat(columnCount - 1)
            let itemSize = viewWidth / CGFloat(columnCount)
            return CGSize(width: itemSize, height: itemSize)
        } else {
            return CGSize()
        }
    }
}
