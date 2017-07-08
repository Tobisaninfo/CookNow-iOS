//
//  SettingsTableViewController.swift
//  CookNow
//
//  Created by Tobias on 15.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit
import PKHUD

class SettingsTableViewController: UITableViewController {
    
    private let aboutSegueIdentifer = "aboutSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    // MARK: - Table DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return IngredientProperty.properties.count
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "restrictionCell", for: indexPath)
            cell.textLabel?.text = IngredientProperty.properties[indexPath.row].name
            
            let property = IngredientProperty.properties[indexPath.row]
            let selected = UserDefaults.standard.bool(forKey: "Property.\(property.id)")
            
            cell.accessoryType = selected ? .checkmark : .none
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "marketTableCell", for: indexPath)
            return cell
        } else { // row == 2
            let cell = tableView.dequeueReusableCell(withIdentifier: "aboutCell", for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 100
        } else {
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return NSLocalizedString("Settings.Restrictions", comment: "Dietary Restrictions")
        } else if section == 1 {
            return NSLocalizedString("Settings.Supermarket", comment: "Preffered Supermarket")
        } else if section == 2 {
            return NSLocalizedString("Settings.Infortmation", comment: "Information")
        }
        return nil
    }
    
    // MARK: - Table View Handler
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let cell = tableView.cellForRow(at: indexPath) {
                let selected = triggerCell(cell: cell)
                
                // Save Settings
                let property = IngredientProperty.properties[indexPath.row]
                UserDefaults.standard.set(selected, forKey: "Property.\(property.id)")
                
                HUD.show(.labeledProgress(title: NSLocalizedString("Settings.Restriction.Update", comment: "Plan Update"), subtitle: nil))
                DispatchQueue.global().async {
                    PlanGenerator.newPlan()
                    DispatchQueue.main.async {
                        HUD.hide(animated: true)
                    }
                }
            }
        } else if indexPath.section == 2 {
            self.performSegue(withIdentifier: aboutSegueIdentifer, sender: self)
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
}
