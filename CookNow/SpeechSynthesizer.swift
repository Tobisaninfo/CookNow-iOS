//
//  SpeechSynthesizer.swift
//  CookNow
//
//  Created by Tobias on 02.07.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation
import AVFoundation

/**
 Enumeration of ```SpeechSynthesizer``` States.
 */
public enum SpeechSynthesizerState {
    /**
     Text-to-speech is running.
     */
    case running
    /**
     SpeechSynthesizer is ready to use.
     */
    case ready
}

/**
 Delegate for the ```SpeechSynthesizer```. This protocoll provides methods to handle text-to-speech.
 */
public protocol SpeechSynthesizerDelegate {
    /**
     This method is invoked then the SpeechSynthesizer finish the text-to-speech process.
     */
    func synthesizerDidEnd()
}

/**
 Class to handle text-to-speech easy.
 */
public class SpeechSynthesizer: NSObject, AVSpeechSynthesizerDelegate {
    
    // MARK: - Properties
    
    private var speechSynthesizer: AVSpeechSynthesizer?
    
    /**
     State of the controller.
     */
    private(set) public var state: SpeechSynthesizerState = .ready
    
    // MARK: - Delegate
    
    /**
     Controller delegate.
     */
    public var delegate: SpeechSynthesizerDelegate?
    
    // MARK: - Methods
    
    /**
     Read a text out to the user.
     - Parameter text: String to read
     */
    public func speak(text: String, usingLanguage language: String) {
        let voice = AVSpeechSynthesisVoice(language: language)
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = voice
        
        speechSynthesizer = AVSpeechSynthesizer()
        speechSynthesizer?.delegate = self
        speechSynthesizer?.speak(speechUtterance)
    }
    
    /**
     Cancel the current text-to-speech process.
     */
    public func cancel() {
        speechSynthesizer?.stopSpeaking(at: .immediate)
    }
    
    // MARK: - Delegate
    
    /**
     Handels the internal delegate.
     */
    final public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        state = .ready
        delegate?.synthesizerDidEnd()
    }
}
