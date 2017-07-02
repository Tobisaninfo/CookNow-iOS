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

class SpeechViewController: UIViewController, SpeechRecognitionDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let speechRecognition = SpeechRecognitionController()
    var speechProcesscor: SpeechProcescor?
    var speechSynthesizer: SpeechSynthesizer?
    
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
        _ = speechRecognition.setup()
        
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
        print(result.bestTranscription.formattedString)
        if let speechProcesscor = speechProcesscor {
            if let result = speechProcesscor.execute(transcript: result.bestTranscription) {
                print(result)

                
                let utterance = AVSpeechUtterance(string: result)
                utterance.voice = AVSpeechSynthesisVoice(language: "de-DE")
                
                let synthesizer = AVSpeechSynthesizer()
                synthesizer.speak(utterance)
            }
        }
    }

    
    @IBAction func speechButtonHandler(_ sender: UIButton) {
        if speechRecognition.state == .listening {
            speechRecognition.stop()
        } else {
            if let speechSynthesizer = speechSynthesizer {
                if speechSynthesizer.state == .running {
                    speechSynthesizer.cancel()
                }
            }
            speechRecognition.start()
        }
    }
    
    @IBAction func backHandle(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
