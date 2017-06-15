//
//  RecipeViewController.swift
//  CookNow
//
//  Created by Tobias on 14.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        DispatchQueue.global().async {
            if let image = ResourceHandler.loadImage(scope: .recipe, id: 1) {
                DispatchQueue.main.sync {
                    self.imageView.image = image
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        descriptionTextView.setContentOffset(CGPoint.zero, animated: true)
    }
    
//    private var backgroundImage: UIImage?
//    private var shadowImage: UIImage?
//    private var backgroundColor: UIColor?
//    private var barBackgroundColor: UIColor?
//    
//    override func viewWillAppear(_ animated: Bool) {
//        backgroundImage = self.navigationController?.navigationBar.backgroundImage(for: .default)
//        shadowImage = self.navigationController?.navigationBar.shadowImage
//        backgroundColor = self.navigationController?.view.backgroundColor
//        barBackgroundColor = self.navigationController?.navigationBar.backgroundColor
//        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.view.backgroundColor = UIColor.clear
//        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = shadowImage
//        self.navigationController?.view.backgroundColor = backgroundColor
//        self.navigationController?.navigationBar.backgroundColor = barBackgroundColor
//    }

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

}
