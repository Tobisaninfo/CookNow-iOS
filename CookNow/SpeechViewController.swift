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
        speechSynthesizer.cancel()
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
        micButton.setImage(#imageLiteral(resourceName: "Microphone-Large"), for: .normal)
        micButton.isHidden = true
        activityView.isHidden = false
        
        DispatchQueue.global().async {
            print(result.bestTranscription.formattedString)
            if let speechProcesscor = self.speechProcesscor {
                let result = speechProcesscor.execute(transcript: result.bestTranscription)
                self.speechSynthesizer.speak(text: result)
            } else {
                self.synthesizerDidEnd()
            }
        }
    }

    func synthesizerDidEnd() {
        DispatchQueue.main.async {
            self.micButton.isHidden = false
            self.activityView.isHidden = true
        }
    }
    
    @IBAction func speechButtonHandler(_ sender: UIButton) {
        if speechRecognition.state == .listening {
            speechRecognition.stop()
            micButton.setImage(#imageLiteral(resourceName: "Microphone-Large"), for: .normal)
        } else {
            if speechSynthesizer.state == .running {
                speechSynthesizer.cancel()
            }
            speechRecognition.start()
            micButton.setImage(#imageLiteral(resourceName: "Microphone-Filled-Large"), for: .normal)
        }
    }
}
