//
//  AboutViewController.swift
//  CookNow
//
//  Created by Tobias on 25.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.text = NSLocalizedString("About", comment: "About")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
