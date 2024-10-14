//
//  BackColumn.swift
//  Scorecard
//
//  Created by Brett Garon on 10/13/24.
//

import SwiftUI

struct BackColumn: View {
    var passedGame : Game
    var adjustment : Int
    init(passedGame: Game, adjustment : Int) {
        self.passedGame = passedGame
        self.adjustment = adjustment
    }
    
    var body: some View {
        ZStack{
            ScorecardRectangle(text: "")
                .offset(y:0)
            ScorecardRectangle(text: "")
                .offset(y:45)
            ScorecardRectangle(text: "")
                .offset(y:90)
            ScorecardRectangle(text: getTotalPar().description)
                .offset(y:135)
            ForEach(passedGame.players.sorted(by: >)){ player in
                ScorecardRectangle(text: (getPlayerFinalScore(player: player) + adjustment).description)
                    .offset(y: makePlayerOffset(index: passedGame.players.sorted(by: >).firstIndex(of: player)!))
            }
        }
    }
    func makePlayerOffset(index : Int)->CGFloat{
        let base = 135
        let step = 45
        var offset = step * (index+1)
        offset += base
        return CGFloat(offset)
    }
    func getPlayerFinalScore(player : Player) -> Int{
        var playerScore : Int = 0
        var bufferScore : Score
        for frame in passedGame.frames {
            bufferScore = frame.scores.first(where: {$0.player == player})!
            playerScore += bufferScore.score
        }
        return playerScore
    }
    func getTotalPar() -> Int{
        var parScore : Int = 0
        var bufferMod : FrameModifier
        for frame in passedGame.frames {
            bufferMod = frame.modifiers.first(where: {$0.name == FrameModifierNames.parName})!
            switch(bufferMod.modifierType){
                case .Arithmetic(let value):
                    parScore += value
                default : break
            }
        }
        return parScore
    }
}

#Preview {
    BackColumn(passedGame: Game(),adjustment: 0)
}
