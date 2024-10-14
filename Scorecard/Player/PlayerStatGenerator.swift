//
//  PlayerStatGenerator.swift
//  Scorecard
//
//  Created by Brett Garon on 10/11/24.
//

import SwiftUI
import SwiftData

struct PlayerStatGenerator: View {
    @Environment(\.modelContext) private var modelContext
    
    //fetch all modifiers with the name teeboxPrototype
    static var fetchDescriptor: FetchDescriptor<FrameModifier> {
        let descriptor = FetchDescriptor<FrameModifier>(
            predicate: #Predicate { $0.name == "teeboxPrototype" }
        )
        return descriptor
    }
    
    @Query(TeeboxPage.fetchDescriptor) private var teeboxPrototypes: [FrameModifier]
    
    var selectedPlayer : Player
    
    init(selectedPlayer: Player) {
        self.selectedPlayer = selectedPlayer
    }
    
    func clearStat(statname : String){
        if(selectedPlayer.modifiers.contains(where: {$0.name == statname})){
            var modsToDelete = selectedPlayer.modifiers.filter({$0.name == statname})
            selectedPlayer.modifiers.removeAll(where: {_ in modsToDelete.contains(where: {$0.name == statname})})
            for mod in modsToDelete{
                modelContext.delete(mod)
            }
        }
    }
    
    func generateTeeboxStats(){
        clearStat(statname:  PlayerModifierNames.averageStrokesPerTeebox)
        var teeboxScoreDictionary = [ModifierType : [Int]]()
        var teeboxMod : FrameModifier?
        var playerScore : Score?
        
        for prototype in teeboxPrototypes {
            teeboxScoreDictionary[prototype.modifierType] = []
        }
        for game in selectedPlayer.games.filter({$0.isFinished}){
            for frame in game.frames {
                teeboxMod = frame.modifiers.first(where: {$0.name == FrameModifierNames.teeboxName})
                playerScore = frame.scores.first(where: {$0.player == selectedPlayer})
                teeboxScoreDictionary[teeboxMod!.modifierType]?.append(playerScore!.score)
            }
        }
        for prototype in teeboxPrototypes {
            var statistic : Double = 0
            var bufferMod : PlayerModifier
            var teeboxName : String = ""
            for teebox in teeboxScoreDictionary.keys{
                statistic = 0
                for score in teeboxScoreDictionary[teebox]!{
                    statistic += Double(score)
                }
                statistic = statistic/Double(teeboxScoreDictionary[teebox]!.count)
                
                switch(teebox){
                    case .String(let value) :
                        teeboxName = value
                    default : break
                }
               
                
                bufferMod = PlayerModifier(modifierType: .String(value: "average strokes from " + teeboxName + " = " + statistic.formatted(.number)), name: PlayerModifierNames.averageStrokesPerTeebox+teeboxName)
                if(selectedPlayer.modifiers.contains(where: {$0.name == bufferMod.name})){
                    selectedPlayer.modifiers.removeAll(where: {$0.name == bufferMod.name})
                }
                modelContext.insert(bufferMod)
                selectedPlayer.modifiers.append(bufferMod)
            }
        }
    }
    
    func generateHoleStats(){
        clearStat(statname:  PlayerModifierNames.averageStrokesPerTeebox)
        var holeScoreDictionary = [ModifierType : [Int]]()
        var holeMod : FrameModifier?
        var playerScore : Score?
        
        for holeNum in 1...4 {
            holeScoreDictionary[.Arithmetic(value: holeNum)] = []
        }
        for game in selectedPlayer.games.filter({$0.isFinished}){
            for frame in game.frames {
                holeMod = frame.modifiers.first(where: {$0.name == FrameModifierNames.holeName})
                playerScore = frame.scores.first(where: {$0.player == selectedPlayer})
                holeScoreDictionary[holeMod!.modifierType]?.append(playerScore!.score)
            }
        }
        var statistic : Double = 0
        var bufferMod : PlayerModifier
        var holeName : String = ""
        for hole in holeScoreDictionary.keys{
            statistic = 0
            for score in holeScoreDictionary[hole]!{
                statistic += Double(score)
            }
            statistic = statistic/Double(holeScoreDictionary[hole]!.count)
            switch(hole){
                case .Arithmetic(let value) :
                    holeName = value.description
                default : break
            }
            bufferMod = PlayerModifier(modifierType: .String(value: "average strokes to " + holeName + " = " + statistic.formatted(.number)), name: PlayerModifierNames.averageStrokesPerHoleName+holeName)
            if(selectedPlayer.modifiers.contains(where: {$0.name == bufferMod.name})){
                selectedPlayer.modifiers.removeAll(where: {$0.name == bufferMod.name})
            }
            modelContext.insert(bufferMod)
            selectedPlayer.modifiers.append(bufferMod)
        }
    }
    
    func generateTeeShotStats(){
        clearStat(statname:PlayerModifierNames.averageStrokesPerTeeShot)
        var teeShotMod : ScoreModifier?
        var teeShotModValue : Int = 0
        var score : Score?
        var totalShots = 0
        var totalMods = 0
        var timestamp : Date
        for game in selectedPlayer.games.filter({$0.isFinished}){
            timestamp = game.timestamp
            for frame in game.frames {
                score = frame.scores.first(where: {$0.player == selectedPlayer})
                teeShotMod = score!.modifiers.first(where: {$0.name == ScoreModifierNames.teeShotName})
                
                if(teeShotMod != nil){
                    totalMods+=1
                    
                    switch(teeShotMod?.modifierType){
                        case.Arithmetic(let value):
                            teeShotModValue = value
                        default : break
                    }
                    
                    totalShots += teeShotModValue
                }
            }
        }
        var statistic = Double(totalShots)/Double(totalMods)
        var bufferMod = PlayerModifier(modifierType: .String(value: "avg Teeshots/Frame = " + statistic.formatted(.number)), name: PlayerModifierNames.averageStrokesPerTeeShot)
        modelContext.insert(bufferMod)
        selectedPlayer.modifiers.append(bufferMod)
    }
    
    func generateApproachStats(){
        clearStat(statname:PlayerModifierNames.averageStrokesPerApproach)
        var approachMod : ScoreModifier?
        var approachModValue : Int = 0
        var score : Score?
        var totalShots = 0
        var totalMods = 0
        for game in selectedPlayer.games{
            for frame in game.frames {
                
                score = frame.scores.first(where: {$0.player == selectedPlayer})
                approachMod = score?.modifiers.first(where: {$0.name == ScoreModifierNames.approachName})
                
                if(approachMod != nil){
                    
                    totalMods+=1
                    
                    switch(approachMod?.modifierType){
                        case.Arithmetic(let value):
                            approachModValue = value
                        default : break
                    }
                    
                    totalShots += approachModValue
                }
            }
        }
        var statistic = Double(totalShots)/Double(totalMods)
        var bufferMod = PlayerModifier(modifierType: .String(value: "avg Approaches/Frame = " + statistic.formatted(.number)), name: PlayerModifierNames.averageStrokesPerApproach)
        modelContext.insert(bufferMod)
        selectedPlayer.modifiers.append(bufferMod)
    }
    
    func generateChipStats(){
        clearStat(statname:PlayerModifierNames.averageChipsPerHole)
        var chipsMod : ScoreModifier?
        var chipsModValue : Int = 0
        var score : Score?
        var totalShots = 0
        var totalMods = 0
        for game in selectedPlayer.games{
            for frame in game.frames {
                
                score = frame.scores.first(where: {$0.player == selectedPlayer})
                chipsMod = score?.modifiers.first(where: {$0.name == ScoreModifierNames.chipsName})
                
                if(chipsMod != nil){
                    
                    totalMods+=1
                    
                    switch(chipsMod?.modifierType){
                        case.Arithmetic(let value):
                            chipsModValue = value
                        default : break
                    }
                    
                    totalShots += chipsModValue
                }
            }
        }
        var statistic = Double(totalShots)/Double(totalMods)
        var bufferMod = PlayerModifier(modifierType: .String(value: "average chips/frame = " + statistic.formatted(.number)), name: PlayerModifierNames.averageChipsPerHole)
        modelContext.insert(bufferMod)
        selectedPlayer.modifiers.append(bufferMod)
    }
    
    func generatePuttStats(){
        clearStat(statname:PlayerModifierNames.averagePuttsPerHole)
        var puttsMod : ScoreModifier?
        var puttsModValue : Int = 0
        var score : Score?
        var totalShots = 0
        var totalMods = 0
        for game in selectedPlayer.games{
            for frame in game.frames {
                score = frame.scores.first(where: {$0.player == selectedPlayer})
                puttsMod = score?.modifiers.first(where: {$0.name == ScoreModifierNames.puttsName})
                if(puttsMod != nil){
                    
                    totalMods+=1
                    
                    switch(puttsMod?.modifierType){
                        case.Arithmetic(let value):
                            puttsModValue = value
                        default : break
                    }
                    
                    totalShots += puttsModValue
                }
            }
        }
        var statistic = Double(totalShots)/Double(totalMods)
        var bufferMod = PlayerModifier(modifierType: .String(value: "average putts/frame = " + statistic.formatted(.number)), name: PlayerModifierNames.averagePuttsPerHole)
        modelContext.insert(bufferMod)
        selectedPlayer.modifiers.append(bufferMod)
    }
    
    func generateHazStats(){
        clearStat(statname:PlayerModifierNames.averageHazardsPerHole)
        var hazMod : ScoreModifier?
        var hazModValue : Int = 0
        var score : Score?
        var totalShots = 0
        var totalMods = 0
        for game in selectedPlayer.games{
            for frame in game.frames {
                
                score = frame.scores.first(where: {$0.player == selectedPlayer})
                hazMod = score?.modifiers.first(where: {$0.name == ScoreModifierNames.teeShotName})
                
                if(hazMod != nil){
                    
                    totalMods+=1
                    
                    switch(hazMod?.modifierType){
                        case.Arithmetic(let value):
                            hazModValue = value
                        default : break
                    }
                    
                    totalShots += hazModValue
                }
            }
        }
        var statistic = Double(totalShots)/Double(totalMods)
        var bufferMod = PlayerModifier(modifierType: .String(value: "average hazards per hole = " + statistic.formatted(.number)), name: PlayerModifierNames.averageHazardsPerHole)
        modelContext.insert(bufferMod)
        selectedPlayer.modifiers.append(bufferMod)
    }
    
    func generatePlusMinusStats(){
        clearStat(statname: PlayerModifierNames.plusMinus)
        var score : Score?
        var par : FrameModifier?
        var totalShots = 0
        var totalFrames = 0
        for game in selectedPlayer.games.filter({$0.isFinished}){
            for frame in game.frames {
                
                score = frame.scores.first(where: {$0.player == selectedPlayer})
                par = frame.modifiers.first(where: {$0.name == FrameModifierNames.parName})
                totalShots += score?.score ?? 0
                switch(par?.modifierType){
                    case .Arithmetic(let value) :
                        totalShots -= value
                    default : break
                }
                
                totalFrames+=1
            }
        }
        var statistic : Double
        statistic = Double(totalShots)/Double(totalFrames)
        var bufferMod = PlayerModifier(modifierType: .String(value: "your Plus/Minus = " + statistic.formatted(.number)), name: PlayerModifierNames.plusMinus)
        modelContext.insert(bufferMod)
        selectedPlayer.modifiers.append(bufferMod)
    }
    
    func generateHandicapStats(){
        clearStat(statname: PlayerModifierNames.handicap)
        var score : Score?
        var par : FrameModifier?
        var totalShots = 0
        var totalFrames = 0
        for game in selectedPlayer.games.filter({$0.isFinished}){
            for frame in game.frames {
                
                score = frame.scores.first(where: {$0.player == selectedPlayer})
                par = frame.modifiers.first(where: {$0.name == FrameModifierNames.parName})
                totalShots += score?.score ?? 0
                switch(par?.modifierType){
                    case .Arithmetic(let value) :
                        totalShots -= value
                    default : break
                }
                
                totalFrames+=1
            }
        }
        var statistic : Double
        statistic = Double(totalShots)/Double(totalFrames)
        statistic = statistic * Double(18)
        var bufferMod = PlayerModifier(modifierType: .String(value: "your handicap = " + statistic.formatted(.number)), name: PlayerModifierNames.handicap)
        modelContext.insert(bufferMod)
        selectedPlayer.modifiers.append(bufferMod)
    }
    
    func generateAvgStrokesStats(){
        clearStat(statname: PlayerModifierNames.averageStrokesPerFrame)
        var score : Score?
        var totalShots = 0
        var totalFrames = 0
        for game in selectedPlayer.games{
            for frame in game.frames {
                
                score = frame.scores.first(where: {$0.player == selectedPlayer})
                totalShots += score?.score ?? 0
                
                totalFrames+=1
            }
        }
        var statistic : Double
        statistic = Double(totalShots)/Double(totalFrames)
        let bufferMod = PlayerModifier(modifierType: .String(value: "your average Strokes per frame = " + statistic.formatted(.number)), name: PlayerModifierNames.averageStrokesPerFrame)
        modelContext.insert(bufferMod)
        selectedPlayer.modifiers.append(bufferMod)
    }
    
    var body: some View {
        Menu("Generate Stat Type"){
            Button("Teebox Stats", action: generateTeeboxStats)
            Button("Hole Stats", action: generateHoleStats)
            Button("Teeshot Stats", action: generateTeeShotStats)
            Button("Approach Stats", action: generateApproachStats)
            Button("Chip Stats", action: generateChipStats)
            Button("Putt Stats", action: generatePuttStats)
            Button("Plus Minus", action: generatePlusMinusStats)
            Button("Handicap", action: generateHandicapStats)
        }
    }
}

#Preview {
    PlayerStatGenerator(selectedPlayer: Player())
}


/*
 private func createStatistics(game : Game, statName : String){
     let averageStrokesPerHoleName = PlayerModifierNames.averageStrokesPerHoleName
     let averageScorePerHoleName = PlayerModifierNames.averageScorePerHoleName
     let averageScorePerGameName = PlayerModifierNames.averageScorePerGameName
     
     var bufferMod : PlayerModifier
     var statisticValue : Double = 0
     var playerStrokes = 0
     
     let scores = createPlayerScores(game: game)
     let parScore = findGamePar(game: game)
     
     switch(statName){
     
     case averageScorePerGameName:
         
         for player in game.players {
             
             playerStrokes = scores[player] ?? parScore
             playerStrokes = playerStrokes - findGamePar(game: game)
             statisticValue = Double(playerStrokes)
             
             bufferMod = PlayerModifier(modifierType: .Double(value: statisticValue), name: statName)
             modelContext.insert(bufferMod)
             player.modifiers.append(bufferMod)
             
             statisticValue = 0.0
         }
         
     case averageScorePerHoleName:
         for player in game.players {
             statisticValue = Double(scores[player] ?? parScore)
             
             statisticValue = statisticValue - Double(parScore)
             
             statisticValue = statisticValue / Double(game.frames.count)
             
             bufferMod = PlayerModifier(modifierType: .Double(value: statisticValue), name: statName)
             
             modelContext.insert(bufferMod)
             player.modifiers.append(bufferMod)
             
             statisticValue = 0.0
         }
     case averageStrokesPerHoleName:
         for player in game.players {
             statisticValue = Double(scores[player] ?? parScore)
                             
             statisticValue = statisticValue / Double(game.frames.count)
             
             bufferMod = PlayerModifier(modifierType: .Double(value: statisticValue), name: statName)
             
             modelContext.insert(bufferMod)
             player.modifiers.append(bufferMod)
             
             statisticValue = 0.0
         }
     
     default : return
     }
 */
 
