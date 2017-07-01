//
//  SpeechViewController.swift
//  CookNow
//
//  Created by Tobias on 24.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class SpeechViewController: UIViewController, SpeechRecognitionDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var speechRecognition: SpeechRecognitionController?
    
    var recipe: Recipe? {
        didSet {
            setImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        speechRecognition = SpeechRecognitionController()
        speechRecognition?.delegate = self
        speechRecognition?.setup()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setImage()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        speechRecognition?.stop()
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
    

    func speechDidRecognize() {
        
    }

    
    @IBAction func speechButtonHandler(_ sender: UIButton) {
        speechRecognition?.start()
    }
    
    @IBAction func backHandle(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
