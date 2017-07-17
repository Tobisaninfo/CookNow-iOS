//
//  SpeechProcesscor.swift
//  CookNow
//
//  Created by Tobias on 02.07.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation
import Speech

/**
 Class to process text from the recognition.
 */
public class SpeechProcescor {

    // MARK: - Types
    
    /**
     Function type for the processing methods.
     */
    public typealias SpeechHandler = (SFTranscription) -> (content: String, language: String)?
    
    // MARK: - Properties
    
    private let recipe: Recipe
    private var currentStep = 0
    
    /**
     Contains the processors.
     */
    public var processors: [SpeechHandler] = []
    
    /**
     Create a new instance of the class.
     - Parameter recipe:
     */
    public init(recipe: Recipe) {
        self.recipe = recipe
        self.processors.append(getIngredinent(transcription:))
        self.processors.append(getDescription(transcription:))
    }
    
    /**
     Execute the processor methods with a transcription.
     - Parameter transcription: Speech recognition transcription
     - Returns: Result string for the text-to-speech or ```nil```
     */
    public func execute(transcript: SFTranscription) -> (content: String, language: String) {
        for processor in processors {
            if let result = processor(transcript) {
                return result
            }
        }
        return (content: "Ich verstehe \(transcript.formattedString) nicht", language: "de")
    }
    
    private func getIngredinent(transcription: SFTranscription) -> (content: String, language: String)? {
        // Check transcription
        if !contains(transcription: transcription, keywords: "welche", "zutaten") &&
            !contains(transcription: transcription, keywords: "welche", "zutat") &&
            !contains(transcription: transcription, keywords: "was", "zutaten") &&
            !contains(transcription: transcription, keywords: "was", "zutat") {
            return nil
        }
        
        // Which step
        if contains(transcription: transcription, keywords: "nächste") ||
            contains(transcription: transcription, keywords: "nächstes") ||
            contains(transcription: transcription, keywords: "danach") {
            currentStep = currentStep + 1
        }
        
        if contains(transcription: transcription, keywords: "zurück") ||
            contains(transcription: transcription, keywords: "davor") {
            currentStep = currentStep - 1
        }
        
        // Create Feedback
        if currentStep < recipe.steps.count {
            var result = ""
            for ingredientUse in recipe.steps[currentStep].ingredients {
                if ingredientUse.ingredient.unit != .Ohne {
                    let unitText = NSLocalizedString("Unit.\(ingredientUse.ingredient.unit)", comment: "Unit")
                    result = result + "\(ingredientUse.amount.formatted) \(unitText) \(ingredientUse.ingredient.name), "
                } else {
                    result = result + "\(ingredientUse.ingredient.name), "
                }
            }
            return (content: result, language: "en")
        } else {
            return (content: "Es gibt keine weiteren Schritte", language: "de")
        }
    }
    
    public func getDescription(transcription: SFTranscription) -> (content: String, language: String)? {
        if !contains(transcription: transcription, keywords: "was", "machen") &&
            !contains(transcription: transcription, keywords: "was", "schritt") &&
            !contains(transcription: transcription, keywords: "welcher", "schritt") &&
            !contains(transcription: transcription, keywords: "was", "tun") {
            return nil
        }
        
        if contains(transcription: transcription, keywords: "nächste") ||
            contains(transcription: transcription, keywords: "nächstes") ||
            contains(transcription: transcription, keywords: "danach") {
            currentStep = currentStep + 1
        }
        
        if contains(transcription: transcription, keywords: "zurück") ||
            contains(transcription: transcription, keywords: "davor") {
            currentStep = currentStep - 1
        }
        
        // Create Feedback
        if currentStep < recipe.steps.count {
            return (content: recipe.steps[currentStep].content, language: "en")
        } else {
            return (content: "Es gibt keine weiteren Schritte", language: "de")
        }
    }
    
    /**
     Check is a list of keywords are in the transcription.
     - Parameter transciption: Text Transcription
     - Parameter keywords: List of keywords
     - Returns: ```true``` All keywords are in the transcription
     */
    public func contains(transcription: SFTranscription, keywords: String...) -> Bool {
        for word in keywords {
            var find = false
            for segment in transcription.segments {
                if word.lowercased() == segment.substring.lowercased() {
                    find = true
                }
            }
            if !find {
                return false
            }
        }
        return true
    }
}
