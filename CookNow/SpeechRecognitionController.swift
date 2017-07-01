//
//  SpeechRecognitionController.swift
//  CookNow
//
//  Created by Tobias on 01.07.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit
import Speech

protocol SpeechRecognitionDelegate {
    func speechDidRecognize()
}

class SpeechRecognitionController: NSObject, SFSpeechRecognizerDelegate {

    var delegate: SpeechRecognitionDelegate?
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "de-DE"))

    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var recorder: AVAudioRecorder?
    private var lowPassResults: Double = 0
    private var levelTimer: Timer!
    
    func setup() -> Bool {
        speechRecognizer?.delegate = self
        
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
        return success
    }
    
    func start() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            print("Audio engine has no input node")
            return
        }
        
        guard let recognitionRequest = recognitionRequest else {
            print("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
            return
        }
        
        recognitionRequest.shouldReportPartialResults = true
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                print(result?.bestTranscription.formattedString ?? "")
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                print("finish")
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
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
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    
    func stop() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recorder?.stop()
        levelTimer.invalidate()
    }
    
    private var counter = 0
    
    // Source https://stackoverflow.com/questions/36008063/ios-9-detect-silent-mode
    func levelTimerCallback(_ timer: Timer) {
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
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        print(available)
    }
}
