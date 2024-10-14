//
//  ScoreCardView.swift
//  Scorecard
//
//  Created by Brett Garon on 10/13/24.
//

import SwiftUI

struct ScoreCardView: View {
    var currentGame : Game
    let baseOffset : CGFloat = -700.0
    init(currentGame: Game) {
        self.currentGame = currentGame
    }
    func determineFrameOffset(index : Int)->CGFloat{
        let offset = 70
        return CGFloat(((index+1)*offset))+baseOffset
    }
    var body: some View {
        ScrollView(.horizontal){
            ZStack{
                Rectangle()
                    .frame(width: 1500,height: 600)
                    .foregroundStyle(.clear)
                FrontColumn(passedGame: currentGame)
                    .offset(x:baseOffset,y:-100)
                ForEach(currentGame.frames.sorted(by: <)){  frame in
                    FrameColumn(passedFrame: frame)
                        .offset(x:determineFrameOffset(index: currentGame.frames.sorted(by: <).firstIndex(of: frame)!),y:-100)
                }
                if(currentGame.isFinished){
                    BackColumn(passedGame: currentGame, adjustment: 0)
                        .offset(x:determineFrameOffset(index: currentGame.frames.count),y:-100)
                    BackColumn(passedGame: currentGame, adjustment: 0-getTotalPar())
                        .offset(x:determineFrameOffset(index: currentGame.frames.count + 1),y:-100)
                }
            }
        }
    }
    func getTotalPar() -> Int{
        var parScore : Int = 0
        var bufferMod : FrameModifier
        for frame in currentGame.frames {
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
    ScoreCardView(currentGame: Game())
}
