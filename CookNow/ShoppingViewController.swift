//
//  ShoppingViewController.swift
//  CookNow
//
//  Created by Tobias on 10.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class ShoppingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    private var shoppingItems: [[ShoppingItem]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ShoppingTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "shoppingCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        shoppingItems = ShoppingItemController.group(shoppingItems: ShoppingItemController.missingItemsForWeeklyPlan())
        tableView.reloadData()
    }

    // MARK: - TableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell", for: indexPath)
        if let cell = cell as? ShoppingTableViewCell, let item = shoppingItems?[indexPath.row] {
            if let unit = Unit(rawValue: Int(item[0].unit)) {
                
                let unitText = NSLocalizedString("Unit.\(unit)", comment: "Unit")
                let amount = item.map({$0.amount}).reduce(0, {$0 + $1})
                
                cell.nameLabel?.text = item[0].name
                cell.descriptionLabel?.text = "\(amount) \(unitText)"
                cell.accessoryType = item[0].done ? .checkmark : .none
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let type = tableView.cellForRow(at: indexPath)?.accessoryType , let item = shoppingItems?[indexPath.row] {
            if type == .checkmark {
                item.forEach({$0.done = false})
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
            } else {
                item.forEach({$0.done = true})
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
            
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.saveContext()
            }
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Event Handler
    @IBAction func doneHandler(_ sender: UIButton) {
        if let shoppingItems = shoppingItems {
            for item in shoppingItems {
                if item[0].done {
                    // Add to panty
                    item.forEach({ _ = $0.addToPantry() })
                    item.forEach({ $0.delete() })
                }
            }
            self.shoppingItems = ShoppingItemController.group(shoppingItems: ShoppingItemController.missingItemsForWeeklyPlan())
            self.tableView.reloadData()
        }
    }
}
