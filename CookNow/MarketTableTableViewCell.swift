//
//  MarketTableTableViewCell.swift
//  CookNow
//
//  Created by Tobias on 08.07.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class MarketTableTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private let marketCellIdentifier = "MarketCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var selectedIndex: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.register(UINib(nibName: "MarketCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: marketCellIdentifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Market.markets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: marketCellIdentifier, for: indexPath)
        if let cell = cell as? MarketCollectionViewCell {
            let marketID = UserDefaults.standard.integer(forKey: "market")
            if marketID == Market.markets[indexPath.row].id {
                cell.isSelected = true
                selectedIndex = indexPath
            }
            DispatchQueue.global().async {
                if let image = ResourceHandler.loadImage(scope: .market, id: Market.markets[indexPath.row].id) {
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedIndex = self.selectedIndex {
            collectionView.cellForItem(at: selectedIndex)?.isSelected = false
        }
        selectedIndex = indexPath
        
        let market = Market.markets[indexPath.row]
        UserDefaults.standard.set(market.id, forKey: "market")
        DispatchQueue.global().async {
            MarketOffer.offers = MarketOfferHandler.list(market: market)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize()
        }
        
        let viewHeight =  collectionView.frame.height - flowLayout.sectionInset.top - flowLayout.sectionInset.bottom
        return CGSize(width: viewHeight, height: viewHeight)
    }
}
