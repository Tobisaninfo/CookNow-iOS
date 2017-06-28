//
//  SpeechViewController.swift
//  CookNow
//
//  Created by Tobias on 24.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class SpeechViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var recipe: Recipe? {
        didSet {
            setImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setImage()
    }
    
    func setImage() {
        if let id = recipe?.id {
            DispatchQueue.global().async {
                if let image = ResourceHandler.loadImage(scope: .recipe, id: id) {
                    DispatchQueue.main.async {
                        self.imageView?.image = image
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    @IBAction func backHandle(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
