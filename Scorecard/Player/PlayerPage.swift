//
//  ItemPage.swift
//  Scorecard
//
//  Created by Brett Garon on 8/28/24.
//

import SwiftUI
import SwiftData

struct PlayerPage: View {
    @Environment(\.modelContext) private var modelContext

    @Query private var items: [Item]
    
    var currentItem : Item = Item()
    
    init(selectedItem : Item){
        currentItem = selectedItem
    }
    init(itemIndex : Int){
        currentItem = items[itemIndex]
    }
    
    var body: some View {
        Text("PlayerPage")
        NavigationSplitView{
            List{
                ForEach(currentItem.players){ player in
                    NavigationLink(player.name, destination: PlayerInfo(selectedPlayer: player))
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
//                ToolbarItem {
//                    Button(action: addPlayer) {
//                        Label("Add Player", systemImage: "plus")
//                    }
//                }
            }
        } detail: {
            Text("Select an item")
        }
       
        
    }
//    private func addPlayer() {
//        withAnimation {
//            let newPlayer = Player()
//            currentItem.players.append(newPlayer)
//            modelContext.insert(newPlayer)
//        }
//    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(currentItem.players[index])
                currentItem.players.remove(at: index)
            }
        }
    }
}

#Preview {
    PlayerPage(itemIndex: 0)
}
