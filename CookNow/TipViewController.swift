//
//  TipViewController.swift
//  CookNow
//
//  Created by Tobias on 13.07.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class TipViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var tip: Tip? {
        didSet {
            nameLabel?.text = tip?.name
            contentLabel?.text = tip?.content
        }
    }
    var categoryName: String? {
        didSet {
            categoryLabel?.text = categoryName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = tip?.name
        contentLabel.text = tip?.content
        categoryLabel.text = categoryName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
