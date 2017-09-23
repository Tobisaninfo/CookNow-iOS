//
//  SpeechRecognitionController.swift
//  CookNow
//
//  Created by Tobias on 01.07.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit
import Speech

/**
 Delegate for the ```SpechRecognitionController```. This protocoll provides methods to handle speech-to-text recognition.
 */
public protocol SpeechRecognitionDelegate {
    /**
     This method is invoked than the text is recognized.
     */
    func speechDidRecognize(result: SFSpeechRecognitionResult)
}

/**
 Enumeration of States for the ```SpeechRecognitionController```.
 */
public enum SpeechRecognitionState {
    /**
     Controller is listening.
     */
    case listening
    /**
     Controller is ready to listen.
     */
    case ready
    /**
     Controller is unautherized.
     */
    case unauthorized
}

/**
 A controller that handles speech-to-text recognition. It handles all setup for audio interaction and user authorization.
 */
public class SpeechRecognitionController: NSObject {

    // MARK: - delegate
    
    /**
     Controller delegate.
     */
    public var delegate: SpeechRecognitionDelegate?
    
    // MARK: - Audio Input
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "de-DE"))

    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private var recorder: AVAudioRecorder?
    private var lowPassResults: Double = 0
    private var levelTimer: Timer?
    
    // MARK: - Properties
    
    /**
     State of the controller.
     */
    private(set) public var state: SpeechRecognitionState = .unauthorized
    
    // MARK: - Methods
    
    /**
     Setup the audio input and user authorization.
     - Returns: ```true``` Speech Recognition is authorized
     */
    public func setup() -> Bool {
        var success = false
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            switch authStatus {
            case .authorized:
                success = true
            case .denied:
                success = false
                print("User denied access to speech recognition")
            case .restricted:
                success = false
                print("Speech recognition restricted on this device")
            case .notDetermined:
                success = false
                print("Speech recognition not yet authorized")
            }
        }
        if success {
            state = .ready
        }
        return success
    }
    
    /**
     Setup the audio input and starts recording.
     */
    public func start() {
        // Cancel previous task
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        // Setup input
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }

        // Setup recognition
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            print("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
            return
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            if let result = result {
                if error != nil || result.isFinal {
                    self.delegate?.speechDidRecognize(result: result)
                    
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                }
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        // Prepare slience recognition
        let url = URL(fileURLWithPath: "/dev/null")
        let settings: [String: Any] = [
            AVSampleRateKey : Int(44100.0),
            AVFormatIDKey : Int(kAudioFormatAppleLossless),
            AVNumberOfChannelsKey : Int(1),
            AVEncoderAudioQualityKey : Int.max
        ]
        
        lowPassResults = 0
        counter = 0
        
        recorder = try? AVAudioRecorder(url: url, settings: settings)
        if recorder != nil {
            recorder?.prepareToRecord()
            recorder?.isMeteringEnabled = true
            recorder?.record()
            levelTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.levelTimerCallback), userInfo: nil, repeats: true)
        }
        
        // Start
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
            state = .listening
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    
    /**
     Stops the audio recording and speech recognition.
     */
    public func stop() {
        recognitionRequest?.endAudio()
        let node = audioEngine.inputNode
        node.removeTap(onBus: 0)
        
        audioEngine.stop()
        
        // Set device to audio output
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try audioSession.setMode(AVAudioSessionModeSpokenAudio)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recorder?.stop()
        levelTimer?.invalidate()
        state = .ready
    }
    
    /**
     Cancel the audio recording and speech recognition.
     */
    public func cancel() {
        recognitionTask?.cancel()
        self.stop()
    }
    
    private var counter = 0
    
    // Source https://stackoverflow.com/questions/36008063/ios-9-detect-silent-mode
    @objc private func levelTimerCallback(_ timer: Timer) {
        recorder?.updateMeters()
        
        if let level = recorder?.peakPower(forChannel: 0) {
            let ALPHA: Double = 0.05
            let peakPowerForChannel: Double = pow(10, (0.05 * Double(level)))
            lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults
            
            // Use here a threshold value to stablish if there is silence or speech
            if peakPowerForChannel < 0.05 {
                counter = counter + 1
                if counter >= 3 {
                    stop()
                }
            } else {
                counter = 0
            }
        }
    }
}
