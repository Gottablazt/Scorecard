//
//  FrontColumn.swift
//  Scorecard
//
//  Created by Brett Garon on 10/13/24.
//

import SwiftUI

struct FrontColumn: View {
    var passedGame : Game
    @State var isShowingPlayerSheet = false
    init(passedGame: Game) {
        self.passedGame = passedGame
    }
    
    var body: some View {
        ZStack{
            ScorecardRectangle(text: "Hole Number")
                .offset(y:0)
            ScorecardRectangle(text: "Teebox")
                .offset(y:45)
            ScorecardRectangle(text: "Hole")
                .offset(y:90)
            ScorecardRectangle(text: "Par")
                .offset(y:135)
            ForEach(passedGame.players){
                player in
                Button{
                    isShowingPlayerSheet.toggle()
                } label: {
                    PlayerRow(player: player)
                }.sheet(isPresented: $isShowingPlayerSheet, content: {
                    PlayerInfo(selectedPlayer: player)
                }).offset(y:makePlayerOffset(index: passedGame.players.firstIndex(of: player)!))
                
            }
        }
        
    }
    func makePlayerOffset(index : Int)->CGFloat{
        var base = 135
        var step = 45
        var offset = step * (index+1)
        offset = offset + base
        return CGFloat(offset)
    }
}

#Preview {
    FrontColumn(passedGame: Game())
}
