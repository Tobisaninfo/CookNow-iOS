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
        self.processors.append(currentIngredinent)
    }
    
    func execute(transcript: SFTranscription) -> String? {
        for processor in processors {
            if let result = processor(transcript) {
                return result
            }
        }
        return nil
    }
    
    func currentIngredinent(transcription: SFTranscription) -> String? {
        // Check transcription
        if !contains(transcription: transcription, keywords: "welche", "zutaten") {
            return nil
        }
        
        // Create Feedback
        if currentStep < recipe.steps.count {
            var result = ""
            for ingredientUse in recipe.steps[currentStep].ingredients {
                result = result + "\(ingredientUse.amountFormatted) \(ingredientUse.ingredient.unit) \(ingredientUse.ingredient.name), "
            }
            return result
        }
        return nil
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
