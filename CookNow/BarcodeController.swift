//
//  BarcodeController.swift
//  CookNow
//
//  Created by Tobias on 01.07.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit
import AVFoundation

protocol BarcodeControllerDelegate {
    func barcodeDidDetect(code: String, frame: CGRect)
}

class BarcodeController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    private var captureDevice: AVCaptureDevice?
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    private let supportedCodeTypes = [AVMetadataObjectTypeUPCECode,
                              AVMetadataObjectTypeCode39Code,
                              AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeCode93Code,
                              AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypeEAN8Code,
                              AVMetadataObjectTypeEAN13Code,
                              AVMetadataObjectTypeAztecCode,
                              AVMetadataObjectTypePDF417Code,
                              AVMetadataObjectTypeQRCode]
    
    var delegate: BarcodeControllerDelegate?
    var allowMultipleMetadataObjects: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
        } catch {
            print(error)
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Start video capture.
        captureSession?.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        captureSession?.stopRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate Methods
    
    private var processing: [String] = []
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            print("No QR/barcode is detected")
            return
        }
        
        for obj in metadataObjects {
            if let metadataObj = obj as? AVMetadataMachineReadableCodeObject {
                if supportedCodeTypes.contains(metadataObj.type) {
                    if metadataObj.stringValue != nil {
                        if let code = metadataObj.stringValue, let bounds = videoPreviewLayer?.transformedMetadataObject(for: metadataObj).bounds, !processing.contains(code) {
                            processing.append(code)
                            delegate?.barcodeDidDetect(code: code, frame: bounds)
                            
                            if !allowMultipleMetadataObjects {
                                break
                            }
                        }
                    }
                }
            }
        }
    }
    
    var isTourchEnable: Bool = false {
        didSet {
            if let captureDevice = self.captureDevice {
                if captureDevice.hasFlash && captureDevice.hasTorch {
                    do {
                        try captureDevice.lockForConfiguration()
                        
                        if isTourchEnable {
                            try captureDevice.setTorchModeOnWithLevel(AVCaptureMaxAvailableTorchLevel)
                        } else {
                            captureDevice.torchMode = AVCaptureTorchMode.off
                        }
                        captureDevice.unlockForConfiguration()
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    func finishReding(code: String) {
        if let index = processing.index(of: code) {
            processing.remove(at: index)
        }
    }
}
