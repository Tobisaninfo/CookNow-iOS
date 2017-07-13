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
    
    private var tipsCategoryNames = [Int:String]()
    private var tips: [Tip] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.global().async {
            self.tipsCategoryNames = TipHandler.list()
            self.tips = TipHandler.list()

            DispatchQueue.main.async {
                self.collectionView?.reloadSections(IndexSet(integer: 1))
            }
        }

        // Register cell classes
        self.collectionView!.register(UINib(nibName: "PlanCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: planReuseIdentifier)
        self.collectionView!.register(UINib(nibName: "TipCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: itemReuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation
    
    var selectedRecipe: Int?
    var selectedTip: Int?

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewControler = segue.destination as? RecipeViewController, let id = selectedRecipe {
            destinationViewControler.recipe = RecipeHandler.get(id: id)
            destinationViewControler.image = ResourceHandler.loadImage(scope: .recipe, id: id)
        }
        
        if let destinationViewControler = segue.destination as? TipViewController, let selectedTip = selectedTip {
            destinationViewControler.tip = tips[selectedTip]
            destinationViewControler.categoryName = tipsCategoryNames[tips[selectedTip].categoryID]
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
            return tips.count
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemReuseIdentifier, for: indexPath)
            
            if let cell = cell as? TipCollectionViewCell {
                cell.nameLabel.text = tips[indexPath.row].name
                cell.categoryLabel.text = tipsCategoryNames[tips[indexPath.row].categoryID]
            }
        
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionElementKindSectionHeader) {
            let headerView:UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "TitleHeander", for: indexPath)
            if let headerView = headerView as? TitleCollectionReusableView {
                if indexPath.section == 0 {
                    headerView.titleLabel.text = NSLocalizedString("Home.WeeklyPlan", comment: "Weekly Plan")
                } else if indexPath.section == 1 {
                    headerView.titleLabel.text = NSLocalizedString("Home.Tips", comment: "Tips")
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
            return CGSize(width: viewWidth, height: 145)
        } else if indexPath.section == 1 {
            let viewWidth =  collectionView.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
            return CGSize(width: viewWidth, height: 55)
        } else {
            return CGSize()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedTip = indexPath.row
        self.performSegue(withIdentifier: "TipDetailSegue", sender: self)
    }
    
    
}
