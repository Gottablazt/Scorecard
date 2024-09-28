//
//  PlayerInfo.swift
//  Scorecard
//
//  Created by Brett Garon on 9/9/24.
//

import SwiftUI
import SwiftData

struct PlayerInfo: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @Query private var players : [Player]
    
    var currentPlayer : Player = Player()
    
    @State var _name : String = ""
    
    init(selectedPlayer : Player){
        currentPlayer = selectedPlayer
        _name = currentPlayer.name
    }
    init(playerIndex : Int){
        currentPlayer = players[playerIndex]
        _name = currentPlayer.name
    }
    var body: some View {
        HStack{
            Spacer()
            Button("Cancel"){
                dismiss()
            }
            Spacer(minLength: 200)
            Button("Done"){
                saveInfo()
                dismiss()
            }
            Spacer()
        }
        Spacer(minLength: 110)
        Text("PlayerInfo")
        TextField(currentPlayer.name, text: $_name)
            .multilineTextAlignment(.center)
        
        ScrollView{
            LazyHStack{
                ForEach(currentPlayer.games){
                    game in
                    GameHistoryView(selectedItem: game)
                }
            }
        }
    }
    
    func saveInfo(){
        currentPlayer.name = _name
      
        modelContext.insert(currentPlayer)
    }
}

#Preview {
    PlayerInfo(selectedPlayer: Player(name: "John"))
}
