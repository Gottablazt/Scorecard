//
//  ScoreInfo.swift
//  Scorecard
//
//  Created by Brett Garon on 9/9/24.
//  MVP 0.0.1 10/3/24 

import SwiftUI
import SwiftData

enum StrokeTypes{
    case teeShot
    case approach
    case chip
    case putt
    case hazard
}

struct ScoreInfo: View {
    @Environment(\.modelContext) private var modelContext
    
    var currentScore : Score
    init(score : Score){
        self.currentScore = score
    }
    
    var body: some View {
        Text(currentScore.player?.name ?? "")
        Text(currentScore.score.description)
        Menu("Add Shot"){
            Button("+TS", action: {
                incrementScore(strokeType: .teeShot)
            })
            Button("+A", action: {
                incrementScore(strokeType: .approach)
            })
            Button("+C", action: {
                incrementScore(strokeType: .chip)
            })
            Button("+P", action: {
                incrementScore(strokeType: .putt)
            })
            Button("+H", action: {
                incrementScore(strokeType: .hazard)
            })
        }
        Button("R", action : resetScore)
    }
    
    
    
    func incrementScore(strokeType : StrokeTypes){
        currentScore.score += 1
        var bufferMod : ScoreModifier?
        switch(strokeType){
            
            case .teeShot:
                
                bufferMod = currentScore.modifiers.first(where: {$0.name == ScoreModifierNames.teeShotName})
                    ?? nil
                if(bufferMod == nil){
                    bufferMod = ScoreModifier(modifierType: .Arithmetic(value: 0), name: ScoreModifierNames.teeShotName)
                }
                
            case .approach:
                
                bufferMod = currentScore.modifiers.first(where: {$0.name == ScoreModifierNames.approachName})
                   ?? nil
                if(bufferMod == nil){
                    bufferMod = ScoreModifier(modifierType: .Arithmetic(value: 0), name: ScoreModifierNames.approachName)
                }
            case .chip:
            
                bufferMod = currentScore.modifiers.first(where: {$0.name == ScoreModifierNames.chipsName}) ?? nil
                if(bufferMod == nil){
                    bufferMod = ScoreModifier(modifierType: .Arithmetic(value: 0), name: ScoreModifierNames.chipsName)
                }
            case .putt:
                
                bufferMod = currentScore.modifiers.first(where: {$0.name == ScoreModifierNames.puttsName}) ?? nil
                if(bufferMod == nil){
                    bufferMod = ScoreModifier(modifierType: .Arithmetic(value: 0), name: ScoreModifierNames.puttsName)
                }
            case .hazard:
                
                bufferMod = currentScore.modifiers.first(where: {$0.name == ScoreModifierNames.hazardsName}) ?? nil
                if(bufferMod == nil){
                    bufferMod = ScoreModifier(modifierType: .Arithmetic(value: 0), name: ScoreModifierNames.hazardsName)
                }
        }
        
        switch(bufferMod!.modifierType){
            case .Arithmetic(let value) :
                bufferMod!.modifierType = .Arithmetic(value: value + 1)
            default: break
        }
        currentScore.modifiers.append(bufferMod!)
        modelContext.insert(bufferMod!)
    }
    
    func resetScore(){
        currentScore.modifiers.removeAll()
        currentScore.score = 0
    }
    
}

#Preview {
    ScoreInfo(score: Score())
}
