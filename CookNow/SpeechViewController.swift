//
//  SpeechViewController.swift
//  CookNow
//
//  Created by Tobias on 24.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit
import Speech
import AVFoundation

class SpeechViewController: UIViewController, SpeechRecognitionDelegate, SpeechSynthesizerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    let speechRecognition = SpeechRecognitionController()
    var speechProcesscor: SpeechProcescor?
    var speechSynthesizer = SpeechSynthesizer()
    
    var recipe: Recipe? {
        didSet {
            if let recipe = recipe {
                speechProcesscor = SpeechProcescor(recipe: recipe)
                setImage()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        speechRecognition.delegate = self
        speechSynthesizer.delegate = self
        _ = speechRecognition.setup()
        
        activityView.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setImage()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        speechRecognition.cancel()
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
    

    func speechDidRecognize(result: SFSpeechRecognitionResult) {
        micButton.setImage(#imageLiteral(resourceName: "mic-icon"), for: .normal)
        micButton.isHidden = true
        activityView.isHidden = false
        
        print(result.bestTranscription.formattedString)
        if let speechProcesscor = speechProcesscor {
            if let result = speechProcesscor.execute(transcript: result.bestTranscription) {
                speechSynthesizer.speak(text: result)
            } else {
                micButton.setImage(#imageLiteral(resourceName: "mic-icon"), for: .normal)
            }
        }
    }

    func synthesizerDidEnd() {
        micButton.isHidden = false
        activityView.isHidden = true
    }
    
    @IBAction func speechButtonHandler(_ sender: UIButton) {
        if speechRecognition.state == .listening {
            speechRecognition.stop()
            micButton.setImage(#imageLiteral(resourceName: "mic-icon"), for: .normal)
        } else {
            if speechSynthesizer.state == .running {
                speechSynthesizer.cancel()
            }
            speechRecognition.start()
            micButton.setImage(#imageLiteral(resourceName: "mic-icon-on"), for: .normal)
        }
    }
    
    @IBAction func backHandle(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
