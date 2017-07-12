//
//  ScannerViewController.swift
//  CookNow
//
//  Created by Tobias on 12.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit
import AVFoundation
import PKHUD

class ScannerViewController: BarcodeController, BarcodeControllerDelegate {
    
    @IBOutlet weak var flashlightButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        view.bringSubview(toFront: flashlightButton)
    }
    
    func barcodeDidDetect(code: String, frame: CGRect) {
        HUD.show(.progress)
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);

        DispatchQueue.global().async {
            if let barcode = IngredientHanler.barcode(code: code) {
                if let ingredient = barcode.ingredient {
                    DispatchQueue.main.async {
                        HUD.flash(.labeledSuccess(title: nil, subtitle: ingredient.name), delay: 2.0) { success in
                            self.finishReding(code: code)
                        }
                    }
                    _ = PantryItem.add(id: ingredient.id, withAmount: barcode.amount)
                } else {
                    DispatchQueue.main.async {
                        HUD.flash(.error, delay: 2.0) { success in
                            self.finishReding(code: code)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    HUD.flash(.error, delay: 2.0) { success in
                        self.finishReding(code: code)
                    }
                }
            }
        }
    }
        
    @IBAction func flashlightHandler(_ sender: Any) {
        isTourchEnable = !isTourchEnable
        flashlightButton.setImage(isTourchEnable ? #imageLiteral(resourceName: "Flash-Filled") : #imageLiteral(resourceName: "Flash"), for: .normal)
    }
}
