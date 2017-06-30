//
//  SettingsTableViewController.swift
//  CookNow
//
//  Created by Tobias on 15.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit
import PKHUD

class SettingsTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let reuseIdentifier = "MarketCell"
    
    @IBOutlet weak var lactoseCell: UITableViewCell!
    @IBOutlet weak var vegetarianCell: UITableViewCell!
    @IBOutlet weak var veganCell: UITableViewCell!
    @IBOutlet weak var eggCell: UITableViewCell!
    
    @IBOutlet weak var marketCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load content
        DispatchQueue.global().async {
            self.markets = MarketHandler.list()
            DispatchQueue.main.sync {
                self.marketCollectionView.reloadData()
            }
        }
        
        // Intial settings
        let userDefaults = UserDefaults.standard
        lactoseCell.accessoryType = userDefaults.bool(forKey: "pref-lactose") ? .checkmark : .none
        vegetarianCell.accessoryType = userDefaults.bool(forKey: "pref-vegetarian") ? .checkmark : .none
        veganCell.accessoryType = userDefaults.bool(forKey: "pref-vegan") ? .checkmark : .none
        eggCell.accessoryType = userDefaults.bool(forKey: "pref-egg") ? .checkmark : .none
        
        // Setup CollectionView
        self.marketCollectionView.register(UINib(nibName: "MarketCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table View Handler
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedCell = tableView.cellForRow(at: indexPath) {
            if selectedCell == lactoseCell {
                let newState = triggerCell(cell: lactoseCell)
                UserDefaults.standard.set(newState, forKey: "pref-lactose")
            } else if selectedCell == vegetarianCell {
                let newState = triggerCell(cell: vegetarianCell)
                UserDefaults.standard.set(newState, forKey: "pref-vegetarian")
            } else if selectedCell == veganCell {
                let newState = triggerCell(cell: veganCell)
                UserDefaults.standard.set(newState, forKey: "pref-vegan")
            } else if selectedCell == eggCell {
                let newState = triggerCell(cell: eggCell)
                UserDefaults.standard.set(newState, forKey: "pref-egg")
            }
        }
        
        if indexPath.section == 3 {
            // Remove Rating
            if indexPath.row == 0 {
                Rating.list()?.forEach({$0.delete()})
                HUD.flash(.labeledSuccess(title: NSLocalizedString("Setting.Clear.Rating", comment: "Rating"), subtitle: nil), delay: 1.0) // TODO Localize
            } else if indexPath.row == 1 {
                HUD.show(.progress)
                DispatchQueue.global().async {
                    PlanGenerator.newPlan()
                    DispatchQueue.main.async {
                        HUD.flash(.labeledSuccess(title: NSLocalizedString("Setting.Clear.Plan", comment: "Plan"), subtitle: nil), delay: 1.0) // TODO Localize
                    }
                }
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func triggerCell(cell: UITableViewCell) -> Bool {
        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
            return false
        } else {
            cell.accessoryType = .checkmark
            return true
        }
    }
    
    // MARK: - Market CollectionView
    
    private var markets: [Market] = []
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return markets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let cell = cell as? MarketCollectionViewCell {
            let marketID = UserDefaults.standard.integer(forKey: "market")
            if marketID == markets[indexPath.row].id {
                cell.isSelected = true
            }
            DispatchQueue.global().async {
                if let image = ResourceHandler.loadImage(scope: .market, id: self.markets[indexPath.row].id) {
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let market = markets[indexPath.row]
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
