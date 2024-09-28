////
////  PlayerSelector.swift
////  Scorecard
////
////  Created by Brett Garon on 9/10/24.
////

import SwiftUI
import SwiftData

struct PlayerSelector: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    
    @Query private var players : [Player]
    
    @State var gamePlayers : [Player]
    
    //var currentItem : Item

    init(currentItem : Item){
        _gamePlayers = State(initialValue: currentItem.players)
        //self.currentItem = currentItem
    }
    
    var body: some View {
        VStack{
            Button("Done"){
                //currentItem.players = gamePlayers
                dismiss()
            }
            ForEach($gamePlayers){
                player in
                Picker(selection: player, label: Text("Select Player")){
                    ForEach(players, id: \.id){
                        option in
                        Text(option.name).tag(option)
                    }
                }
            }
        }
    }
}

#Preview {
    PlayerSelector(currentItem: Item())
}
