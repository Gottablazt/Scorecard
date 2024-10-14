//
//  PlayerListView.swift
//  Scorecard
//
//  Created by Brett Garon on 9/10/24.
//  MVP 0.0.1 10/3/24

import SwiftUI
import SwiftData

struct PlayerListView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var potentialPlayerList : [Player]
    
    var body: some View {
        
        Text("PlayerListPage")
        
        NavigationSplitView{
            
            Button(action: addPlayer, label: {
                Text("add Player")
            })
            
            List{
                ForEach(potentialPlayerList){ player in
                    NavigationLink(player.name, destination : PlayerInfo(selectedPlayer: player))
                } .onDelete(perform: deleteItems)
            }
            
        } detail: {
            Text("Select a player")
        }
        
    }
    
    private func addPlayer() {
        let newPlayer = Player()
        modelContext.insert(newPlayer)
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(potentialPlayerList[index])
            }
        }
    }
    
}

#Preview {
    PlayerListView()
}
