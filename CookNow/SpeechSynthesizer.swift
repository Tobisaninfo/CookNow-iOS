//
//  SpeechSynthesizer.swift
//  CookNow
//
//  Created by Tobias on 02.07.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation
import AVFoundation

enum SpeechSynthesizerState {
    case running
    case ready
}

protocol SpeechSynthesizerDelegate {
    func synthesizerDidEnd()
}

class SpeechSynthesizer: NSObject, AVSpeechSynthesizerDelegate {
    
    private let voice = AVSpeechSynthesisVoice.speechVoices().first(where: { $0.name == "Anna (Enhanced)" })
    private var speechSynthesizer: AVSpeechSynthesizer?
    
    private(set) var state: SpeechSynthesizerState = .ready
    
    var delegate: SpeechSynthesizerDelegate?
    
    override init() {
        super.init()
    }
    
    func speak(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = voice
        
        speechSynthesizer = AVSpeechSynthesizer()
        speechSynthesizer?.delegate = self
        speechSynthesizer?.speak(speechUtterance)
    }
    
    func cancel() {
        speechSynthesizer?.stopSpeaking(at: .immediate)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        state = .ready
        delegate?.synthesizerDidEnd()
    }
}
