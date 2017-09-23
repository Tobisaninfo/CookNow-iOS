//
//  BarcodeController.swift
//  CookNow
//
//  Created by Tobias on 01.07.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit
import AVFoundation

/**
 Protocoll to handle events from ```BarcodeController```.
 */
public protocol BarcodeControllerDelegate {
    /**
     This function is called, than a barcode is recognized. You have to call the method ```BarcodeController.finishReading(code:)``` to end up the recognition process.
     - Parameter code: Barcode as String
     - Parameter frame: Frame in camera view, there the code is recognized
     */
    func barcodeDidDetect(code: String, frame: CGRect)
}

/**
 An UIViewController for Barcode Recogition. This ViewController adds a ```AVCaptureVideoPreviewLayer``` on top of the view stack and starts an ```AVCaptureSession```.
 */
public class BarcodeController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    private var captureDevice: AVCaptureDevice?
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                              AVMetadataObject.ObjectType.code39,
                              AVMetadataObject.ObjectType.code39Mod43,
                              AVMetadataObject.ObjectType.code93,
                              AVMetadataObject.ObjectType.code128,
                              AVMetadataObject.ObjectType.ean8,
                              AVMetadataObject.ObjectType.ean13,
                              AVMetadataObject.ObjectType.aztec,
                              AVMetadataObject.ObjectType.pdf417,
                              AVMetadataObject.ObjectType.qr]
    
    // MARK: - Delegate
    
    /**
     Delegate for the BarcodeController.
     */
    public var delegate: BarcodeControllerDelegate?
    
    // MARK: - Properties
    
    /**
     Allow to recognize multiple codes at the same time.
     */
    public var allowMultipleMetadataObjects: Bool = false
    
    
    /**
     Enable the devices tourch, if available.
     */
    public var isTourchEnable: Bool = false {
        didSet {
            if let captureDevice = self.captureDevice {
                if captureDevice.hasFlash && captureDevice.hasTorch {
                    do {
                        try captureDevice.lockForConfiguration()
                        
                        if isTourchEnable {
                            try captureDevice.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
                        } else {
                            captureDevice.torchMode = AVCaptureDevice.TorchMode.off
                        }
                        captureDevice.unlockForConfiguration()
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    // MARK: - ViewController
    
    /**
     Is called, then the view is loaded.
     */
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        // Configure Autofocus
        do {
            try captureDevice?.lockForConfiguration()
            captureDevice?.focusPointOfInterest = CGPoint(x: 0.5, y: 0.5)
            captureDevice?.autoFocusRangeRestriction = .near
            captureDevice?.focusMode = .continuousAutoFocus
            captureDevice?.unlockForConfiguration()
        } catch {
            print("Fail to set autofocus: \(error)")
        }
        
        // Setup capture session and preview.
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
        } catch {
            print(error)
            return
        }
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        // Start video capture.
        captureSession?.startRunning()
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        captureSession?.stopRunning()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate Methods
    
    private var processing: [String] = []
    
    /**
     Handles the recognized barcodes.
     */
    public final func metadataOutput(captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            return
        }
        
        for obj in metadataObjects {
            if let metadataObj = obj as? AVMetadataMachineReadableCodeObject {
                if supportedCodeTypes.contains(metadataObj.type) {
                    if metadataObj.stringValue != nil {
                        if let code = metadataObj.stringValue, let bounds = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)?.bounds, !processing.contains(code) {
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
    
    /**
     Mark barcode as finish.
     - Parameter code: Barcode from the delegate method ```BarcodeControllerDelegate.barcodeDidDetect(code:frame:)```
     */
    public func finishReding(code: String) {
        if let index = processing.index(of: code) {
            processing.remove(at: index)
        }
    }
}
