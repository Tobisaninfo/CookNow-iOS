//
//  SpeechProcesscor.swift
//  CookNow
//
//  Created by Tobias on 02.07.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation
import Speech

class SpeechProcescor {

    typealias SpeechHandler = (SFTranscription) -> String?
    
    private let recipe: Recipe
    private var currentStep = 0
    
    private var processors: [SpeechHandler] = []
    
    init(recipe: Recipe) {
        self.recipe = recipe
        self.processors.append(getIngredinent(transcription:))
        self.processors.append(getDescription(transcription:))
    }
    
    func execute(transcript: SFTranscription) -> String {
        for processor in processors {
            if let result = processor(transcript) {
                return result
            }
        }
        return "Ich verstehe \(transcript.formattedString) nicht"
    }
    
    func getIngredinent(transcription: SFTranscription) -> String? {
        // Check transcription
        if !contains(transcription: transcription, keywords: "welche", "zutaten") &&
            !contains(transcription: transcription, keywords: "welche", "zutat") &&
            !contains(transcription: transcription, keywords: "was", "zutaten") &&
            !contains(transcription: transcription, keywords: "was", "zutat") {
            return nil
        }
        
        // Which step
        if contains(transcription: transcription, keywords: "nächste") ||
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
                result = result + "\(ingredientUse.amountFormatted) \(ingredientUse.ingredient.unit) \(ingredientUse.ingredient.name), "
            }
            return result
        } else {
            return "Es gibt keine weiteren Schritte"
        }
    }
    
    func getDescription(transcription: SFTranscription) -> String? {
        if !contains(transcription: transcription, keywords: "was", "machen") &&
            !contains(transcription: transcription, keywords: "was", "schritt") &&
            !contains(transcription: transcription, keywords: "welcher", "schritt") &&
            !contains(transcription: transcription, keywords: "was", "tun") {
            return nil
        }
        
        if contains(transcription: transcription, keywords: "nächste") ||
            contains(transcription: transcription, keywords: "danach") {
            currentStep = currentStep + 1
        }
        
        if contains(transcription: transcription, keywords: "zurück") ||
            contains(transcription: transcription, keywords: "davor") {
            currentStep = currentStep - 1
        }
        
        // Create Feedback
        if currentStep < recipe.steps.count {
            return recipe.steps[currentStep].content
        } else {
            return "Es gibt keine weiteren Schritte"
        }
    }
    
    private func contains(transcription: SFTranscription, keywords: String...) -> Bool {
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
