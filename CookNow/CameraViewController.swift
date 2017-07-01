//
//  CameraViewController.swift
//  CookNow
//
//  Created by Tobias on 01.07.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class CameraViewController: BarcodeController, BarcodeControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        allowMultipleMetadataObjects = true
        


    }
    
    func barcodeDidDetect(code: String, frame: CGRect) {
        var qrCodeFrameView:UIView?
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
        qrCodeFrameView?.frame = frame
    }
    
}
